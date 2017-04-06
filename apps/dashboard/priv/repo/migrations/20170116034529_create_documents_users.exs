defmodule Dashboard.Data.Main.Repo.Migrations.CreateDocumentsUsers do
  use Ecto.Migration

  def change do
    create table(:documents_users) do
      add :document_id, references(:documents)
      add :user_id, references(:users)

      # A user can make changes to the document
      add :edit, :boolean, default: true

      # A user can share the document
      add :share, :boolean, default: true

      # A user can change config settings, other users permissions, etc.
      add :configure, :boolean, default: true
    end
    create index(:documents_users, [:document_id, :user_id])
  end
end
