defmodule WebPortal.APIService do
  use WebPortal.Web, :model

  schema "api_service" do
    field :name, :string
    field :description, :string
    field :url, :string
    field :auth, :boolean
    has_many :endpoints, WebPortal.APIEndpoint

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> validate_required([])
  end
end
