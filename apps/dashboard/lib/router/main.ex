defmodule Dashboard.Router.Main do
  use Plug.Router
  require Logger

  plug Plug.Logger
  plug :match
  plug :dispatch
  plug Plug.Parsers, parsers: [:urlencoded]

  get "/" do



    conn
    |> send_resp(200, "ok")
    |> halt
  end

  forward "/endpoint", to: Dashboard.Nodes.Plug

  get _ do
    send_resp(conn, 404, "oops")
  end
end
