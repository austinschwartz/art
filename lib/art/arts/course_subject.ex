defmodule Art.Arts.CourseSubject do
  use Ecto.Schema
  import Ecto.Changeset

  schema "courses_subjects" do
    field :course_id, :id
    field :subject_id, :id

    timestamps()
  end

  @doc false
  def changeset(course_subject, attrs) do
    course_subject
    |> cast(attrs, [])
    |> validate_required([])
  end
end
