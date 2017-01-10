defmodule Blackboard.Repo.Migrations.CreateRecvNode do
  use Ecto.Migration

  def change do
    create table(:recv_nodes) do
      add :uuid, :string
      add :name, :string
      add :request_url, :string

      timestamps()
    end

  end
end
