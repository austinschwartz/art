defmodule Art.Arts do
  @moduledoc """
  The Arts context.
  """

  import Ecto.Query, warn: false
  alias Art.Repo
  alias Ecto.Multi

  alias Art.Arts.Author

  @doc """
  Returns the list of authors.

  ## Examples

      iex> list_authors()
      [%Author{}, ...]

  """
  def list_authors do
    Repo.all(Author)
  end

  @doc """
  Gets a single author.

  Raises `Ecto.NoResultsError` if the Author does not exist.

  ## Examples

      iex> get_author!(123)
      %Author{}

      iex> get_author!(456)
      ** (Ecto.NoResultsError)

  """
  def get_author!(id), do: Repo.get!(Author, id)

  @doc """
  Creates a author.

  ## Examples

      iex> create_author(%{field: value})
      {:ok, %Author{}}

      iex> create_author(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_author(attrs \\ %{}) do
    %Author{}
    |> Author.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a author.

  ## Examples

      iex> update_author(author, %{field: new_value})
      {:ok, %Author{}}

      iex> update_author(author, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_author(%Author{} = author, attrs) do
    author
    |> Author.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a author.

  ## Examples

      iex> delete_author(author)
      {:ok, %Author{}}

      iex> delete_author(author)
      {:error, %Ecto.Changeset{}}

  """
  def delete_author(%Author{} = author) do
    Repo.delete(author)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking author changes.

  ## Examples

      iex> change_author(author)
      %Ecto.Changeset{data: %Author{}}

  """
  def change_author(%Author{} = author, attrs \\ %{}) do
    Author.changeset(author, attrs)
  end

  alias Art.Arts.Subject

  @doc """
  Returns the list of subjects.

  ## Examples

      iex> list_subjects()
      [%Subject{}, ...]

  """
  def list_subjects do
    Repo.all(Subject)
  end

  @doc """
  Gets a single subject.

  Raises `Ecto.NoResultsError` if the Subject does not exist.

  ## Examples

      iex> get_subject!(123)
      %Subject{}

      iex> get_subject!(456)
      ** (Ecto.NoResultsError)

  """
  def get_subject!(id), do: Repo.get!(Subject, id)

  def get_subject_with_courses!(id) do
    Subject
      |> Ecto.Query.preload(:courses)
      |> Repo.get!(id)
  end

  @doc """
  Creates a subject.

  ## Examples

      iex> create_subject(%{field: value})
      {:ok, %Subject{}}

      iex> create_subject(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_subject(attrs \\ %{}) do
    %Subject{}
    |> Subject.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a subject.

  ## Examples

      iex> update_subject(subject, %{field: new_value})
      {:ok, %Subject{}}

      iex> update_subject(subject, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_subject(%Subject{} = subject, attrs) do
    subject
    |> Subject.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a subject.

  ## Examples

      iex> delete_subject(subject)
      {:ok, %Subject{}}

      iex> delete_subject(subject)
      {:error, %Ecto.Changeset{}}

  """
  def delete_subject(%Subject{} = subject) do
    Repo.delete(subject)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking subject changes.

  ## Examples

      iex> change_subject(subject)
      %Ecto.Changeset{data: %Subject{}}

  """
  def change_subject(%Subject{} = subject, attrs \\ %{}) do
    Subject.changeset(subject, attrs)
  end

  alias Art.Arts.Course

  @doc """
  Returns the list of courses.

  ## Examples

      iex> list_courses()
      [%Course{}, ...]

  """
  def list_courses do
    Course
      |> Ecto.Query.preload(:subjects)
      |> Repo.all
    #Repo.all(Course)
  end

  @doc """
  Gets a single course.

  Raises `Ecto.NoResultsError` if the Course does not exist.

  ## Examples

      iex> get_course!(123)
      %Course{}

      iex> get_course!(456)
      ** (Ecto.NoResultsError)

  """
  def get_course!(id) do
    Course
      |> Ecto.Query.preload(:subjects)
      |> Repo.get!(id)
    #Repo.get!(Course, id)
  end

  defp parse_subjects(nil), do: []

  defp parse_subjects(subjects) do
    # Repo.insert_all requires the inserted_at and updated_at to be filled out
    # and they should have time truncated to the second that is why we need this
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    for subject <- String.split(subjects, ","),
        subject = subject |> String.trim(),
        subject != "",
        do: %{name: subject, inserted_at: now, updated_at: now}
  end

  def create_course(attrs \\ %{}) do
    multi_result =
      Multi.new()
      # use multi to insert all the courses, so the subjects are rolled back when there
      # is an error in course creation
      |> ensure_subjects(attrs)
      |> Multi.insert(:course, fn %{subjects: subjects} ->
        # This chunk of code remains the same, the only difference is we let
        # Ecto.Multi handle insertion of the course
        %Course{}
        |> Course.changeset(attrs)
        |> Ecto.Changeset.put_assoc(:subjects, subjects)
      end)
      # Finally, we run all of this in a single transaction
      |> Repo.transaction()

    # a multi result can be an :ok tagged tuple with the data from all steps
    # or an error tagged tuple with the failure step's atom and relevant data
    # in this case we only expect failures in Course insertion
    case multi_result do
      {:ok, %{course: course}} -> {:ok, course}
      {:error, :course, changeset, _} -> {:error, changeset}
    end
  end

  # This is identical to `create_course`
  def update_course(%Course{} = course, attrs) do
    multi_result =
      Multi.new()
      |> ensure_subjects(attrs)
      |> Multi.update(:course, fn %{subjects: subjects} ->
        course
        |> Course.changeset(attrs)
        |> Ecto.Changeset.put_assoc(:subjects, subjects)
      end)
      |> Repo.transaction()

    case multi_result do
      {:ok, %{course: course}} -> {:ok, course}
      {:error, :course, changeset, _} -> {:error, changeset}
    end
  end

  # We have created an ensure subjects to use the multi struct passed along and the
  # repo associated with it to allow rolling back tag inserts
  defp ensure_subjects(multi, attrs) do
    subjects = parse_subjects(attrs["subjects"])

    multi
    |> Multi.insert_all(:insert_subjects, Subject, subjects, on_conflict: :nothing)
    |> Multi.run(:subjects, fn repo, _changes ->
      subject_names = for s <- subjects, do: s.name
      {:ok, repo.all(from s in Subject, where: s.name in ^subject_names)}
    end)
  end

  @doc """
  Deletes a course.

  ## Examples

      iex> delete_course(course)
      {:ok, %Course{}}

      iex> delete_course(course)
      {:error, %Ecto.Changeset{}}

  """
  def delete_course(%Course{} = course) do
    Repo.delete(course)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking course changes.

  ## Examples

      iex> change_course(course)
      %Ecto.Changeset{data: %Course{}}

  """
  def change_course(%Course{} = course, attrs \\ %{}) do
    Course.changeset(course, attrs)
  end
end
