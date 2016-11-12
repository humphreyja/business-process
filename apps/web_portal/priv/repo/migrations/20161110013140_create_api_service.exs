defmodule WebPortal.Repo.Migrations.CreateAPIService do
  use Ecto.Migration

  def change do
    create table(:api_service) do

      timestamps()
    end

  end
end
