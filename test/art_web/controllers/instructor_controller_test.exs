defmodule ArtWeb.InstructorControllerTest do
  use ArtWeb.ConnCase

  alias Art.Arts

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:instructor) do
    {:ok, instructor} = Arts.create_instructor(@create_attrs)
    instructor
  end

  describe "index" do
    test "lists all instructors", %{conn: conn} do
      conn = get(conn, Routes.instructor_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Instructors"
    end
  end

  describe "new instructor" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.instructor_path(conn, :new))
      assert html_response(conn, 200) =~ "New Instructor"
    end
  end

  describe "create instructor" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.instructor_path(conn, :create), instructor: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.instructor_path(conn, :show, id)

      conn = get(conn, Routes.instructor_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Instructor"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.instructor_path(conn, :create), instructor: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Instructor"
    end
  end

  describe "edit instructor" do
    setup [:create_instructor]

    test "renders form for editing chosen instructor", %{conn: conn, instructor: instructor} do
      conn = get(conn, Routes.instructor_path(conn, :edit, instructor))
      assert html_response(conn, 200) =~ "Edit Instructor"
    end
  end

  describe "update instructor" do
    setup [:create_instructor]

    test "redirects when data is valid", %{conn: conn, instructor: instructor} do
      conn = put(conn, Routes.instructor_path(conn, :update, instructor), instructor: @update_attrs)
      assert redirected_to(conn) == Routes.instructor_path(conn, :show, instructor)

      conn = get(conn, Routes.instructor_path(conn, :show, instructor))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, instructor: instructor} do
      conn = put(conn, Routes.instructor_path(conn, :update, instructor), instructor: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Instructor"
    end
  end

  describe "delete instructor" do
    setup [:create_instructor]

    test "deletes chosen instructor", %{conn: conn, instructor: instructor} do
      conn = delete(conn, Routes.instructor_path(conn, :delete, instructor))
      assert redirected_to(conn) == Routes.instructor_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.instructor_path(conn, :show, instructor))
      end
    end
  end

  defp create_instructor(_) do
    instructor = fixture(:instructor)
    %{instructor: instructor}
  end
end
