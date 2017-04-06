defmodule SSO.Plugs.CaptureParams do
  @behaviour Plug

  import Plug.Conn
  import Phoenix.Controller
  import Logger

  def init(o), do: o

  def call(%{params: %{"client_key" => client_key}} = conn, _) do
    conn
    |> put_session(:client_key, client_key)
  end

  def call(conn, _) do
    conn
  end
end
