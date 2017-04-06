defmodule Coherence.SessionView do
  use SSO.Coherence.Web, :view

  import Plug.Conn

  def return_to_app_path(conn) do
    SSO.Client.get_home_page(get_session(conn, :client_key))
  end
end
