defmodule Dashboard.SampleData.Blackboard do
  require Logger
  use GenServer

  def run(conn) do
    Dashboard.SampleData.Blackboard.start_link


    GenServer.cast(:run_nodes, ["run", conn])

    {:ok, status, body} = rec_response(200, "OK", 5_000)
    Plug.Conn.send_resp(conn, status, body)
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

  def start_link do
    GenServer.start_link(__MODULE__, :ok, [name: :run_nodes])
  end

  def init(:ok) do
    {:ok, %{default_response: %{status: 200, body: "OK"}}}
  end

  def handle_cast(["run",conn], state) do

    IO.puts "#{inspect conn.params}"

    run_triggers(conn.params, conn)
    {:noreply, state}
  end

  defp run_triggers(%{"uuid" => uuid} = params, conn) do
    Enum.each(Dashboard.SampleData.Nodes.data, fn {id, obj} ->
      if uuid == Map.get(obj, :uuid) do
        run_trigger(obj, conn)
      end
    end)
  end

  defp run_triggers(%{}, conn), do: send(conn.owner, :none)
  defp run_trigger(%{type: "Trigger"} = trigger, conn) do
    send(conn.owner, {:default, fetch_default_status(trigger), fetch_default_body(trigger), fetch_timeout(trigger)})


  end

  defp fetch_default_body(%{type: "Trigger", default_body: body}), do: body
  defp fetch_default_body(%{type: "Trigger"}), do: "OK"

  defp fetch_default_status(%{type: "Trigger", default_status: status}), do: status
  defp fetch_default_status(%{type: "Trigger"}), do: 200

  defp fetch_timeout(%{type: "Trigger", timeout: timeout}), do: timeout
  defp fetch_timeout(%{type: "Trigger"}), do: 0
end
