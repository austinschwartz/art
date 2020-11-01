defmodule Art.Arts do
  @moduledoc """
  The Arts context.
  """

  import Ecto.Query, warn: false
  alias Art.Repo
  alias Ecto.Multi

  alias Art.Arts.Subject
  alias Art.Arts.Website
  alias Art.Arts.Course
  alias Art.Arts.Instructor

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

  @doc """
  Returns the list of courses.

  ## Examples

      iex> list_courses()
      [%Course{}, ...]

  """
  def list_courses do
    Course
      |> Ecto.Query.preload(:subjects)
      |> Ecto.Query.preload(:website)
      |> Ecto.Query.preload(:instructor)
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
      |> Ecto.Query.preload(:website)
      |> Ecto.Query.preload(:instructor)
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

  def maybe_insert_website(multi, nil), do: multi
  def maybe_insert_website(multi, %{"website" => website}) do
    multi
    |> Multi.insert(
        :insert_website,
        Website.changeset(%Website{},
          %{"name" => website}),
          on_conflict: :nothing
        )
      |> Multi.run(:website, fn repo, _changes ->
        website_name = website
        {:ok, repo.all(from w in Website, where: w.name == ^website_name)}
      end)
  end

  def put_assoc_if_website(course, nil), do: course
  def put_assoc_if_website(course, %{website: [website]}) do
    course |> Ecto.Changeset.put_assoc(:website, website)
  end

  def maybe_insert_instructor(multi, nil), do: multi
  def maybe_insert_instructor(multi, %{"instructor" => instructor}) do
    multi
    |> Multi.insert(
        :insert_instructor,
        Website.changeset(%Instructor{},
          %{"name" => instructor}),
          on_conflict: :nothing
        )
      |> Multi.run(:instructor, fn repo, _changes ->
        instructor_name = instructor
        {:ok, repo.all(from i in Instructor, where: i.name == ^instructor_name)}
      end)
  end

  def put_assoc_if_instructor(course, nil), do: course
  def put_assoc_if_instructor(course, %{instructor: [instructor]}) do
    course |> Ecto.Changeset.put_assoc(:instructor, instructor)
  end

  def create_course(attrs \\ %{}) do
    multi = Multi.new()
      |> maybe_insert_website(attrs)
      |> maybe_insert_instructor(attrs)
      |> ensure_subjects(attrs)
      |> Multi.insert(:course, fn m ->
        %Course{}
          |> Course.changeset(attrs)
          |> Ecto.Changeset.put_assoc(:subjects, m[:subjects])
          |> put_assoc_if_website(m)
          |> put_assoc_if_instructor(m)
      end)
    # Finally, we run all of this in a single transaction
    multi_result = Repo.transaction(multi)
    case multi_result do
      {:ok, %{course: course}} -> {:ok, course}
      {:error, :course, changeset, _} -> {:error, changeset}
      x -> x
    end
  end

  def create_course_old(attrs \\ %{}) do
    multi = Multi.new()

    # Insert subjects
    multi = multi
      |> ensure_subjects(attrs)

    # Insert courses
    multi = multi
      |> Multi.insert(:course, fn %{subjects: subjects} ->
        %Course{}
          |> Course.changeset(attrs)
          |> Ecto.Changeset.put_assoc(:subjects, subjects)
      end)
    # Finally, we run all of this in a single transaction
    multi_result = Repo.transaction(multi)
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
  # repo associated with it to allow rolling back subject inserts
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

  @doc """
  Returns the list of websites.

  ## Examples

      iex> list_websites()
      [%Website{}, ...]

  """
  def list_websites do
    Repo.all(Website)
  end

  @doc """
  Gets a single website.

  Raises `Ecto.NoResultsError` if the Website does not exist.

  ## Examples

      iex> get_website!(123)
      %Website{}

      iex> get_website!(456)
      ** (Ecto.NoResultsError)

  """
  def get_website!(id), do: Repo.get!(Website, id)

  @doc """
  Creates a website.

  ## Examples

      iex> create_website(%{field: value})
      {:ok, %Website{}}

      iex> create_website(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_website(attrs \\ %{}) do
    %Website{}
    |> Website.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a website.

  ## Examples

      iex> update_website(website, %{field: new_value})
      {:ok, %Website{}}

      iex> update_website(website, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_website(%Website{} = website, attrs) do
    website
    |> Website.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a website.

  ## Examples

      iex> delete_website(website)
      {:ok, %Website{}}

      iex> delete_website(website)
      {:error, %Ecto.Changeset{}}

  """
  def delete_website(%Website{} = website) do
    Repo.delete(website)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking website changes.

  ## Examples

      iex> change_website(website)
      %Ecto.Changeset{data: %Website{}}

  """
  def change_website(%Website{} = website, attrs \\ %{}) do
    Website.changeset(website, attrs)
  end


  @doc """
  Returns the list of instructors.

  ## Examples

      iex> list_instructors()
      [%Instructor{}, ...]

  """
  def list_instructors do
    Repo.all(Instructor)
  end

  @doc """
  Gets a single instructor.

  Raises `Ecto.NoResultsError` if the Instructor does not exist.

  ## Examples

      iex> get_instructor!(123)
      %Instructor{}

      iex> get_instructor!(456)
      ** (Ecto.NoResultsError)

  """
  def get_instructor!(id), do: Repo.get!(Instructor, id)

  @doc """
  Creates a instructor.

  ## Examples

      iex> create_instructor(%{field: value})
      {:ok, %Instructor{}}

      iex> create_instructor(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_instructor(attrs \\ %{}) do
    %Instructor{}
    |> Instructor.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a instructor.

  ## Examples

      iex> update_instructor(instructor, %{field: new_value})
      {:ok, %Instructor{}}

      iex> update_instructor(instructor, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_instructor(%Instructor{} = instructor, attrs) do
    instructor
    |> Instructor.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a instructor.

  ## Examples

      iex> delete_instructor(instructor)
      {:ok, %Instructor{}}

      iex> delete_instructor(instructor)
      {:error, %Ecto.Changeset{}}

  """
  def delete_instructor(%Instructor{} = instructor) do
    Repo.delete(instructor)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking instructor changes.

  ## Examples

      iex> change_instructor(instructor)
      %Ecto.Changeset{data: %Instructor{}}

  """
  def change_instructor(%Instructor{} = instructor, attrs \\ %{}) do
    Instructor.changeset(instructor, attrs)
  end

  def delete_all() do
    Repo.delete_all(Instructor)
    Repo.delete_all(CourseSubject)
    Repo.delete_all(Subject)
    Repo.delete_all(Website)
    Repo.delete_all(Course)
  end
end
