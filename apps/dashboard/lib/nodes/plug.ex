defmodule Dashboard.Nodes.Plug do
  import Plug.Conn

  def init(options), do: options

  def call(conn, _opts) do
    conn = parse(conn)
    Dashboard.Nodes.Thread.start_thread(conn)
    {:ok, status, body, content_type} = rec_response(200, "OK", "text/plain", 5_000)

    conn
    |> put_resp_content_type(content_type)
    |> send_resp(status, body)
  end

  def parse(conn, opts \\ []) do
    opts = Keyword.put_new(opts, :parsers, [Plug.Parsers.URLENCODED, Plug.Parsers.MULTIPART])
    Plug.Parsers.call(conn, Plug.Parsers.init(opts))
  end

  defp rec_response(status, body, content_type, timeout) do
    receive do
      {:ok, status, body, content_type} = res -> res
      {:default, status, body, content_type, timeout} -> rec_response(status, body, content_type, timeout)
      :none -> {:ok, status, body, content_type}
    after
      timeout -> {:ok, status, body, content_type}
    end
  end
end
