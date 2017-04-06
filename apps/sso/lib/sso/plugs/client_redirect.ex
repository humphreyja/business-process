defmodule SSO.Plugs.ClientRedirect do
  @behaviour Plug

  import Plug.Conn
  import Phoenix.Controller
  import Logger

  def init(o), do: o

  def call(%{assigns: %{current_user: %{name: name, email: email}}} = conn, _) do
    token = %{name: name, email: email}
    {_, conn} = SSO.RespondToken.try_respond_with_token(conn, token, :sign_in)
    conn
  end

  def call(conn, _) do
    conn
  end
end
