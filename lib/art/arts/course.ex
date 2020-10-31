defmodule Art.Arts.Course do
  use Ecto.Schema
  import Ecto.Changeset

  schema "courses" do
    field :cost, :float
    field :end, :date
    field :name, :string
    field :start, :date
    many_to_many :subjects, Art.Arts.Subject, join_through: "courses_subjects", on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(course, attrs) do
    course
    |> cast(attrs, [:name, :start, :end, :cost])
    |> validate_required([:name, :start, :end, :cost])
  end
end
