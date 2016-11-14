defmodule WebPortal.Repo.Migrations.CreateAPIService do
  use Ecto.Migration

  def change do
    create table(:api_service) do
      add :name, :string
      add :description, :text
      add :url, :string
      add :auth, :boolean, default: false
      timestamps()
    end

  end
end
