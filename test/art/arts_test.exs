defmodule Art.ArtsTest do
  use Art.DataCase

  alias Art.Arts

  describe "authors" do
    alias Art.Arts.Author

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def author_fixture(attrs \\ %{}) do
      {:ok, author} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Arts.create_author()

      author
    end

    test "list_authors/0 returns all authors" do
      author = author_fixture()
      assert Arts.list_authors() == [author]
    end

    test "get_author!/1 returns the author with given id" do
      author = author_fixture()
      assert Arts.get_author!(author.id) == author
    end

    test "create_author/1 with valid data creates a author" do
      assert {:ok, %Author{} = author} = Arts.create_author(@valid_attrs)
      assert author.name == "some name"
    end

    test "create_author/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Arts.create_author(@invalid_attrs)
    end

    test "update_author/2 with valid data updates the author" do
      author = author_fixture()
      assert {:ok, %Author{} = author} = Arts.update_author(author, @update_attrs)
      assert author.name == "some updated name"
    end

    test "update_author/2 with invalid data returns error changeset" do
      author = author_fixture()
      assert {:error, %Ecto.Changeset{}} = Arts.update_author(author, @invalid_attrs)
      assert author == Arts.get_author!(author.id)
    end

    test "delete_author/1 deletes the author" do
      author = author_fixture()
      assert {:ok, %Author{}} = Arts.delete_author(author)
      assert_raise Ecto.NoResultsError, fn -> Arts.get_author!(author.id) end
    end

    test "change_author/1 returns a author changeset" do
      author = author_fixture()
      assert %Ecto.Changeset{} = Arts.change_author(author)
    end
  end

  describe "subjects" do
    alias Art.Arts.Subject

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def subject_fixture(attrs \\ %{}) do
      {:ok, subject} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Arts.create_subject()

      subject
    end

    test "list_subjects/0 returns all subjects" do
      subject = subject_fixture()
      assert Arts.list_subjects() == [subject]
    end

    test "get_subject!/1 returns the subject with given id" do
      subject = subject_fixture()
      assert Arts.get_subject!(subject.id) == subject
    end

    test "create_subject/1 with valid data creates a subject" do
      assert {:ok, %Subject{} = subject} = Arts.create_subject(@valid_attrs)
      assert subject.name == "some name"
    end

    test "create_subject/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Arts.create_subject(@invalid_attrs)
    end

    test "update_subject/2 with valid data updates the subject" do
      subject = subject_fixture()
      assert {:ok, %Subject{} = subject} = Arts.update_subject(subject, @update_attrs)
      assert subject.name == "some updated name"
    end

    test "update_subject/2 with invalid data returns error changeset" do
      subject = subject_fixture()
      assert {:error, %Ecto.Changeset{}} = Arts.update_subject(subject, @invalid_attrs)
      assert subject == Arts.get_subject!(subject.id)
    end

    test "delete_subject/1 deletes the subject" do
      subject = subject_fixture()
      assert {:ok, %Subject{}} = Arts.delete_subject(subject)
      assert_raise Ecto.NoResultsError, fn -> Arts.get_subject!(subject.id) end
    end

    test "change_subject/1 returns a subject changeset" do
      subject = subject_fixture()
      assert %Ecto.Changeset{} = Arts.change_subject(subject)
    end
  end

  describe "courses" do
    alias Art.Arts.Course

    @valid_attrs %{cost: 120.5, end: ~D[2010-04-17], name: "some name", start: ~D[2010-04-17]}
    @update_attrs %{cost: 456.7, end: ~D[2011-05-18], name: "some updated name", start: ~D[2011-05-18]}
    @invalid_attrs %{cost: nil, end: nil, name: nil, start: nil}

    def course_fixture(attrs \\ %{}) do
      {:ok, course} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Arts.create_course()

      course
    end

    test "list_courses/0 returns all courses" do
      course = course_fixture()
      assert Arts.list_courses() == [course]
    end

    test "get_course!/1 returns the course with given id" do
      course = course_fixture()
      assert Arts.get_course!(course.id) == course
    end

    test "create_course/1 with valid data creates a course" do
      assert {:ok, %Course{} = course} = Arts.create_course(@valid_attrs)
      assert course.cost == 120.5
      assert course.end == ~D[2010-04-17]
      assert course.name == "some name"
      assert course.start == ~D[2010-04-17]
    end

    test "create_course/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Arts.create_course(@invalid_attrs)
    end

    test "update_course/2 with valid data updates the course" do
      course = course_fixture()
      assert {:ok, %Course{} = course} = Arts.update_course(course, @update_attrs)
      assert course.cost == 456.7
      assert course.end == ~D[2011-05-18]
      assert course.name == "some updated name"
      assert course.start == ~D[2011-05-18]
    end

    test "update_course/2 with invalid data returns error changeset" do
      course = course_fixture()
      assert {:error, %Ecto.Changeset{}} = Arts.update_course(course, @invalid_attrs)
      assert course == Arts.get_course!(course.id)
    end

    test "delete_course/1 deletes the course" do
      course = course_fixture()
      assert {:ok, %Course{}} = Arts.delete_course(course)
      assert_raise Ecto.NoResultsError, fn -> Arts.get_course!(course.id) end
    end

    test "change_course/1 returns a course changeset" do
      course = course_fixture()
      assert %Ecto.Changeset{} = Arts.change_course(course)
    end
  end
end
