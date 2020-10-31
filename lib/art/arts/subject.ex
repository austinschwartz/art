defmodule Art.Arts.Subject do
  use Ecto.Schema
  import Ecto.Changeset

  schema "subjects" do
    field :name, :string
    many_to_many :courses, Art.Arts.Course, join_through: "courses_subjects", on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(subject, attrs) do
    subject
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
