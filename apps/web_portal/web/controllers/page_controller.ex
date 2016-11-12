defmodule WebPortal.PageController do
  use WebPortal.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
