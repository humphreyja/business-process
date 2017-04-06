defmodule SSO.User do
  use SSO.Web, :model
  use Coherence.Schema

  @users "users"
  @admins "admins"

  schema "users" do
    field :name, :string
    field :email, :string
    field :admin, :boolean
    coherence_schema

    timestamps
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:name, :email] ++ coherence_fields)
    |> validate_required([:name, :email])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> validate_coherence(params)
  end

  def admin_changeset(model, params \\ %{}) do
    model
    |> cast(params, [:name, :email, :admin] ++ coherence_fields)
    |> validate_required([:name, :email])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> validate_coherence(params)
  end

  def users(query) do
    where(query, [u], not u.admin)
  end

  def admins(query) do
    where(query, [u], u.admin)
  end
end
