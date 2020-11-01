defmodule Art.Repo.Migrations.CreateWebsites do
  use Ecto.Migration

  def change do
    create table(:websites) do
      add :name, :string

      timestamps()
    end
    create unique_index(:websites, [:name])

  end
end
