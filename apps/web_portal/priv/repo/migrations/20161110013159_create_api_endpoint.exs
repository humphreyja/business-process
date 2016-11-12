defmodule WebPortal.Repo.Migrations.CreateAPIEndpoint do
  use Ecto.Migration

  def change do
    create table(:api_endpoint) do

      timestamps()
    end

  end
end
