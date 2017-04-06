defmodule SSO.Plugs.Authorized do
  @behaviour Plug

  import Plug.Conn
  import Phoenix.Controller
  import Logger

  def init(o), do: o

  def call(%{assigns: %{current_user: current_user}} = conn, _) do
    if current_user.admin do
      conn
    else
      conn
      |> flash_and_redirect
    end
  end

  def call(conn, _) do
    conn
    |> flash_and_redirect
  end

  defp flash_and_redirect(conn) do
    conn
    |> put_flash(:error, "Invalid Access")
    |> redirect(to: "/")
    |> halt
  end
end
