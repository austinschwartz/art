defmodule Art.ArtsTest do
  use Art.DataCase

  alias Art.Arts

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

  describe "websites" do
    alias Art.Arts.Website

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def website_fixture(attrs \\ %{}) do
      {:ok, website} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Arts.create_website()

      website
    end

    test "list_websites/0 returns all websites" do
      website = website_fixture()
      assert Arts.list_websites() == [website]
    end

    test "get_website!/1 returns the website with given id" do
      website = website_fixture()
      assert Arts.get_website!(website.id) == website
    end

    test "create_website/1 with valid data creates a website" do
      assert {:ok, %Website{} = website} = Arts.create_website(@valid_attrs)
      assert website.name == "some name"
    end

    test "create_website/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Arts.create_website(@invalid_attrs)
    end

    test "update_website/2 with valid data updates the website" do
      website = website_fixture()
      assert {:ok, %Website{} = website} = Arts.update_website(website, @update_attrs)
      assert website.name == "some updated name"
    end

    test "update_website/2 with invalid data returns error changeset" do
      website = website_fixture()
      assert {:error, %Ecto.Changeset{}} = Arts.update_website(website, @invalid_attrs)
      assert website == Arts.get_website!(website.id)
    end

    test "delete_website/1 deletes the website" do
      website = website_fixture()
      assert {:ok, %Website{}} = Arts.delete_website(website)
      assert_raise Ecto.NoResultsError, fn -> Arts.get_website!(website.id) end
    end

    test "change_website/1 returns a website changeset" do
      website = website_fixture()
      assert %Ecto.Changeset{} = Arts.change_website(website)
    end
  end

  describe "instructors" do
    alias Art.Arts.Instructor

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def instructor_fixture(attrs \\ %{}) do
      {:ok, instructor} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Arts.create_instructor()

      instructor
    end

    test "list_instructors/0 returns all instructors" do
      instructor = instructor_fixture()
      assert Arts.list_instructors() == [instructor]
    end

    test "get_instructor!/1 returns the instructor with given id" do
      instructor = instructor_fixture()
      assert Arts.get_instructor!(instructor.id) == instructor
    end

    test "create_instructor/1 with valid data creates a instructor" do
      assert {:ok, %Instructor{} = instructor} = Arts.create_instructor(@valid_attrs)
      assert instructor.name == "some name"
    end

    test "create_instructor/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Arts.create_instructor(@invalid_attrs)
    end

    test "update_instructor/2 with valid data updates the instructor" do
      instructor = instructor_fixture()
      assert {:ok, %Instructor{} = instructor} = Arts.update_instructor(instructor, @update_attrs)
      assert instructor.name == "some updated name"
    end

    test "update_instructor/2 with invalid data returns error changeset" do
      instructor = instructor_fixture()
      assert {:error, %Ecto.Changeset{}} = Arts.update_instructor(instructor, @invalid_attrs)
      assert instructor == Arts.get_instructor!(instructor.id)
    end

    test "delete_instructor/1 deletes the instructor" do
      instructor = instructor_fixture()
      assert {:ok, %Instructor{}} = Arts.delete_instructor(instructor)
      assert_raise Ecto.NoResultsError, fn -> Arts.get_instructor!(instructor.id) end
    end

    test "change_instructor/1 returns a instructor changeset" do
      instructor = instructor_fixture()
      assert %Ecto.Changeset{} = Arts.change_instructor(instructor)
    end
  end
end
