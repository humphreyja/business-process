defmodule Blackboard.RecvNode do
  use Blackboard.Web, :model

  schema "recv_nodes" do
    field :uuid, :string
    field :name, :string
    field :request_url, :string

    timestamps()
  end

  def gen_uuid do
    :crypto.strong_rand_bytes(64)
    |> Base.url_encode64
    |> binary_part(0, 64)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:uuid, :name, :request_url])
    |> validate_required([:uuid, :name, :request_url])
  end
end
