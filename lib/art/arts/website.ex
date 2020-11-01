defmodule Art.Arts.Website do
  use Ecto.Schema
  import Ecto.Changeset

  schema "websites" do
    field :name, :string
    has_many :courses, Art.Arts.Course

    timestamps()
  end

  @doc false
  def changeset(website, attrs) do
    website
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
