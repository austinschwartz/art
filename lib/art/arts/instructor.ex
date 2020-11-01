defmodule Art.Arts.Instructor do
  use Ecto.Schema
  import Ecto.Changeset

  schema "instructors" do
    field :name, :string
    has_many :courses, Art.Arts.Course

    timestamps()
  end

  @doc false
  def changeset(instructor, attrs) do
    instructor
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
