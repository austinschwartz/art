defmodule ArtWeb.InstructorController do
  use ArtWeb, :controller

  alias Art.Arts
  alias Art.Arts.Instructor

  def index(conn, _params) do
    instructors = Arts.list_instructors()
    render(conn, "index.html", instructors: instructors)
  end

  def new(conn, _params) do
    changeset = Arts.change_instructor(%Instructor{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"instructor" => instructor_params}) do
    case Arts.create_instructor(instructor_params) do
      {:ok, instructor} ->
        conn
        |> put_flash(:info, "Instructor created successfully.")
        |> redirect(to: Routes.instructor_path(conn, :show, instructor))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    instructor = Arts.get_instructor!(id)
    render(conn, "show.html", instructor: instructor)
  end

  def edit(conn, %{"id" => id}) do
    instructor = Arts.get_instructor!(id)
    changeset = Arts.change_instructor(instructor)
    render(conn, "edit.html", instructor: instructor, changeset: changeset)
  end

  def update(conn, %{"id" => id, "instructor" => instructor_params}) do
    instructor = Arts.get_instructor!(id)

    case Arts.update_instructor(instructor, instructor_params) do
      {:ok, instructor} ->
        conn
        |> put_flash(:info, "Instructor updated successfully.")
        |> redirect(to: Routes.instructor_path(conn, :show, instructor))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", instructor: instructor, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    instructor = Arts.get_instructor!(id)
    {:ok, _instructor} = Arts.delete_instructor(instructor)

    conn
    |> put_flash(:info, "Instructor deleted successfully.")
    |> redirect(to: Routes.instructor_path(conn, :index))
  end
end
