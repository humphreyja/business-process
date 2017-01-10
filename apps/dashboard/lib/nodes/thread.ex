defmodule Dashboard.Nodes.Thread do
  alias Dashboard.Nodes.Catch
  alias Plug.Conn

  def start_thread(%Conn{} = conn) do
    IO.puts "Starting"
    spawn(fn -> execute_connection(conn.params, conn) end)
  end

  defp execute_connection(%{"uuid" => uuid}, conn) do
    Enum.each(Dashboard.SampleData.Nodes.data, fn {_id, obj} ->
      if uuid == Map.get(obj, :uuid) do
        Catch.execute(obj, conn.owner, request_variables(conn), %{})
      end
    end)
  end
  defp execute_connection(%{}, conn), do: send conn.owner, :none

  defp request_variables(conn) do
    Map.merge(conn.body_params, conn.params)
  end

  def next(node, parent_pid, req_vars, vars, []) do
    IO.puts "Finished with: #{inspect vars}"
    IO.puts "And Request: #{inspect req_vars}"

    Catch.terminate(node, parent_pid, req_vars, vars)
  end
  def next(_node, parent_pid, req_vars, vars, next) do
    execute_nodes_by_id(next, parent_pid, req_vars, vars)
  end

  defp execute_nodes_by_id([], _, req_vars, vars) do
    IO.puts "Finished with: #{inspect vars}"
    IO.puts "And Request: #{inspect req_vars}"
    :ok
  end
  defp execute_nodes_by_id([id | ids], parent_pid, req_vars, vars) do
    IO.puts "Spawning node: #{inspect Map.get(Dashboard.SampleData.Nodes.data, id)}"

    spawn(fn ->
      Catch.execute(Map.get(Dashboard.SampleData.Nodes.data, id), parent_pid, req_vars, vars)
    end)
    execute_nodes_by_id(ids, parent_pid, req_vars, vars)
  end


  # Keep nodes alive for a time period to accept responses from their children.
  # Expose an api to the base.ex modules that can capture responses.
  defp rec_response(timeout) do
    receive do
      :ok -> :ok
    after
      timeout -> :ok
    end
  end
end
