defmodule Dashboard.Test.Router.MainTest do
  use ExUnit.Case, async: true
  use Plug.Test
  alias Dashboard.Router.Main, as: MainRouter

  @opts MainRouter.init([])

  test "root returns ok" do
    # Create a test connection
    conn = conn(:get, "/")

    # Invoke the plug
    conn = MainRouter.call(conn, @opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "ok"
  end

  test "random page returns 404" do
    # Create a test connection
    conn = conn(:get, "/random_route")

    # Invoke the plug
    conn = MainRouter.call(conn, @opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 404
    assert conn.resp_body == "oops"
  end
end
