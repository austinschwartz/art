defmodule Art.Repo.Migrations.AddWebsiteId do
  use Ecto.Migration

  def change do
    alter table("courses") do
      add :website_id, references(:websites, on_delete: :nothing)
    end
  end
end
