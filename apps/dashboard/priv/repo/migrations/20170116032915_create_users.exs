defmodule Dashboard.Data.Main.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :uuid, :string
    end
    create unique_index(:users, [:uuid])
  end
end
