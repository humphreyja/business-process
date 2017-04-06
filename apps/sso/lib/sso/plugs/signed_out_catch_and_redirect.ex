defmodule SSO.Plugs.SignedOutCatchAndRedirect do
  @behaviour Plug

  import Plug.Conn
  import Phoenix.Controller
  import Logger

  def init(o), do: o

  def call(%{assigns: %{current_user: current_user}} = conn, _) when not is_nil(current_user) do
    conn
  end

  def call(conn, _) do
    if do_redirect(conn.path_info) do
      conn
      |> redirect(to: "/")
      |> halt
    else
      conn
    end
  end

  defp do_redirect(["sign-out"]), do: true
  defp do_redirect(_), do: false
end
