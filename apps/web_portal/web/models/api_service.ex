defmodule WebPortal.APIService do
  use WebPortal.Web, :model

  schema "api_service" do
    field :name, :string
    field :description, :string
    field :url, :string
    has_many :endpoints, WebPortal.Endpoint

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
