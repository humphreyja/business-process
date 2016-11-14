defmodule WebPortal.Repo.Migrations.CreateAPIEndpoint do
  use Ecto.Migration

  def change do
    create table(:api_endpoint) do
      add :name, :string
      add :description, :text
      add :url, :string
      add :method, :string
      add :headers, :string
      add :auth, :boolean, default: false

      add :api_service_id, references(:api_service)
      timestamps()
    end
    create index(:api_endpoint, [:api_service_id])
  end
end
