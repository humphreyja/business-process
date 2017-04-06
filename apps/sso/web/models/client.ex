defmodule SSO.Client do
  use SSO.Web, :model

  schema "clients" do
    field :name, :string
    field :client_key, :string
    field :sign_in_redirect_url, :string
    field :sign_out_redirect_url, :string
    field :home_page, :string
    field :secret, :string
    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :client_key, :home_page, :sign_in_redirect_url, :sign_out_redirect_url, :secret])
    |> validate_required([:client_key, :home_page, :sign_in_redirect_url, :sign_out_redirect_url, :secret])
    |> unique_constraint(:client_key)
  end

  def get_home_page(client_key) do
    case SSO.Repo.get_by(SSO.Client, client_key: client_key) do
      nil -> nil
      client -> client.home_page
    end
  end
end
