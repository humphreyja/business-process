defmodule Dashboard.Data.Main.Repo.Migrations.CreatePages do
  use Ecto.Migration

  def change do
    create table(:pages) do
      add :name, :string
      add :document_id, references(:documents)
    end
    create index(:pages, [:document_id])
  end
end
