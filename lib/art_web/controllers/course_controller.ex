defmodule ArtWeb.CourseController do
  use ArtWeb, :controller

  alias Art.Arts
  alias Art.Arts.Course

  def index(conn, _params) do
    courses = Arts.list_courses()
    render(conn, "index.html", courses: courses)
  end

  def new(conn, _params) do
    changeset = Arts.change_course(%Course{subjects: []})
    websites = Arts.list_websites() |> Enum.map(&{&1.name, &1.id})
    instructors = Arts.list_instructors() |> Enum.map(&{&1.name, &1.id})
    render(conn, "new.html", websites: websites, instructors: instructors, changeset: changeset)
  end

  def create(conn, %{"course" => course_params}) do
    IO.inspect "create params"
    IO.inspect course_params
    websites = Arts.list_websites() |> Enum.map(&{&1.name, &1.id})
    instructors = Arts.list_instructors() |> Enum.map(&{&1.name, &1.id})

    case Arts.create_course(course_params) do
      {:ok, course} ->
        conn
        |> put_flash(:info, "Course created successfully.")
        |> redirect(to: Routes.course_path(conn, :show, course))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", websites: websites, instructors: instructors, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    course = Arts.get_course!(id)
    render(conn, "show.html", course: course)
  end

  def edit(conn, %{"id" => id}) do
    course = Arts.get_course!(id)
    websites = Arts.list_websites() |> Enum.map(&{&1.name, &1.id})
    instructors = Arts.list_instructors() |> Enum.map(&{&1.name, &1.id})
    changeset = Arts.change_course(course)
    render(conn, "edit.html", course: course, websites: websites, instructors: instructors, changeset: changeset)
  end

  def update(conn, %{"id" => id, "course" => course_params}) do
    IO.inspect "update params"
    IO.inspect course_params
    course = Arts.get_course!(id)
    websites = Arts.list_websites() |> Enum.map(&{&1.name, &1.id})
    instructors = Arts.list_instructors() |> Enum.map(&{&1.name, &1.id})

    case Arts.update_course(course, course_params) do
      {:ok, course} ->
        conn
        |> put_flash(:info, "Course updated successfully.")
        |> redirect(to: Routes.course_path(conn, :show, course))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", course: course, websites: websites, instructors: instructors, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    course = Arts.get_course!(id)
    {:ok, _course} = Arts.delete_course(course)

    conn
    |> put_flash(:info, "Course deleted successfully.")
    |> redirect(to: Routes.course_path(conn, :index))
  end
end
