defmodule Art.Repo.Migrations.CreateInstructors do
  use Ecto.Migration

  def change do
    create table(:instructors) do
      add :name, :string

      timestamps()
    end
    alter table("courses") do
      add :instructor_id, references(:instructors, on_delete: :nothing)
    end
  end
end
