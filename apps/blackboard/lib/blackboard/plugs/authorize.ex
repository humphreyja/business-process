defmodule Blackboard.Plugs.Authorize do
  @behaviour Plug

  import Plug.Conn
  import Phoenix.Controller
  import Logger

  def init(o), do: o

  def call(%{assigns: %{current_user: current_user}} = conn, _) do
    conn
  end

  def call(conn, _) do
    conn
    |> flash_and_redirect
  end

  defp validate_user(%{digest: digest, user: user}) do
    # validate untampered object.
  end

  defp flash_and_redirect(conn) do
    conn
    |> put_flash(:error, "Invalid Access")
    |> put_session(:authorization_pre_redirect_route, conn.request_path)
    |> redirect(external: Application.get_env(:blackboard, :authorization_server_sign_in, ""))
    |> halt
  end
end
