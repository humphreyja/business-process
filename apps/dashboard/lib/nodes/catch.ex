defmodule Dashboard.Nodes.Catch do
  use Dashboard.Nodes.Triggers.Catch
  use Dashboard.Nodes.Computation.Catch

  def execute(node, request_pid, request_variables, variables) do
    case execute_node(node, request_pid, request_variables, variables) do
      {:ok, new_variables} ->
          Dashboard.Nodes.Thread.next(node, request_pid, request_variables, new_variables)
      :error ->
          terminate(node, request_pid, request_variables, variables)
    end
  end

  def terminate(node, request_pid, request_variables, variables) do
    terminate_node(node, request_pid, request_variables, variables)
  end
end
