defmodule Dashboard.Data.Main.Repo.Migrations.CreateAuthroizationTokensDocuments do
  use Ecto.Migration

  def change do
    create table(:auth_tokens_documents) do
      add :authorization_token_id, references(:authorization_tokens)
      add :document_id, references(:documents)
    end
    create index(:auth_tokens_documents, [:authorization_token_id, :document_id])
  end
end
