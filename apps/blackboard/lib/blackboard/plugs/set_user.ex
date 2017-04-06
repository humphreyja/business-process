defmodule Blackboard.Plugs.SetUser do
  @behaviour Plug

  import Plug.Conn
  import Phoenix.Controller
  import Logger

  def init(o), do: o

  def call(conn, _) do
    conn
    |> get_session(:current_user)
    |> set_user(conn)
  end

  defp set_user(nil, conn), do: conn
  defp set_user(user, conn) do
    conn
    |> assign(:current_user, user)
  end
end
