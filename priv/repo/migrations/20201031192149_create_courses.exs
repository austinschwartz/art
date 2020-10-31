defmodule Art.Repo.Migrations.CreateCourses do
  use Ecto.Migration

  def change do
    create table(:courses) do
      add :name, :string
      add :start, :date
      add :end, :date
      add :cost, :float

      timestamps()
    end

  end
end
