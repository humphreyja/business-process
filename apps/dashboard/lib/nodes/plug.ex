defmodule Dashboard.Nodes.Plug do
  import Plug.Conn

  def init(options), do: options

  def call(conn, _opts) do
    conn = fetch_query_params(conn)
    Dashboard.Nodes.Thread.start_thread(conn)
    {:ok, status, body} = rec_response(200, "OK", 5_000)
    send_resp(conn, status, body)
  end

  defp rec_response(status, body, timeout) do
    receive do
      {:ok, status, body} = res -> res
      {:default, status, body, timeout} -> rec_response(status, body, timeout)
      :none -> {:ok, status, body}
    after
      timeout -> {:ok, status, body}
    end
  end
end
