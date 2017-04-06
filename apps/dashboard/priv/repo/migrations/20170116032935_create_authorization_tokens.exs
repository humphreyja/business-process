defmodule Dashboard.Data.Main.Repo.Migrations.CreateAuthorizationTokens do
  use Ecto.Migration

  def change do
    create table(:authorization_tokens) do
      add :name, :string
      add :permissions, :jsonb
      add :user_id, references(:users)
      add :token, :string
      add :refresh_token, :string
      add :expire_time, :datetime
      timestamps
    end
    create index(:authorization_tokens, [:user_id])
  end
end
