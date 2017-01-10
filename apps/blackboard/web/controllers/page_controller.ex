defmodule Blackboard.PageController do
  use Blackboard.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def settings(conn, _params) do
    render conn, "settings.html"
  end

  def editor(conn, _params) do
    render conn, "editor2.html"
  end
end
