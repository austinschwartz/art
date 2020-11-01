defmodule Art.Arts.Course do
  use Ecto.Schema
  import Ecto.Changeset

  schema "courses" do
    field :cost, :float
    field :end, :date
    field :name, :string
    field :start, :date
    many_to_many :subjects, Art.Arts.Subject, join_through: "courses_subjects", on_replace: :delete
    belongs_to :website, Art.Arts.Website
    belongs_to :instructor, Art.Arts.Instructor

    timestamps()
  end

  @doc false
  def changeset(course, attrs) do
    course
    |> cast(attrs, [:name, :start, :end, :cost, :website_id, :instructor_id])
    |> validate_required([:name])
  end
end
