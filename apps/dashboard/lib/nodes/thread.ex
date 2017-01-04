defmodule Dashboard.Nodes.Thread do
  alias Dashboard.Nodes.Catch
  alias Plug.Conn

  def start_thread(%Conn{} = conn) do
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
    conn.params
  end

  def next(%{next: []} = node, request_pid, req_vars, vars) do
    Catch.terminate(node, request_pid, req_vars, vars)
  end
  def next(%{next: nodeIds}, request_pid, req_vars, vars) do
    execute_nodes_by_id(nodeIds, request_pid, req_vars, vars)
  end

  defp execute_nodes_by_id([], _, _, _), do: :ok
  defp execute_nodes_by_id([id | ids], request_pid, req_vars, vars) do
    spawn(fn ->
      Catch.execute(Map.get(Dashboard.SampleData.Nodes.data, id), request_pid, req_vars, vars)
    end)
    execute_nodes_by_id(ids, request_pid, req_vars, vars)
  end
end
