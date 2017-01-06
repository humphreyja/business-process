defmodule Dashboard.Nodes.Catch do
  use Dashboard.Nodes.Triggers.Catch
  use Dashboard.Nodes.Computation.Catch

  def execute(node, request_pid, request_variables, variables) do
    case execute_node(node, request_pid, request_variables, variables) do
      {:ok, new_variables} ->
        Dashboard.Nodes.Thread.next(node, request_pid, request_variables, new_variables)
      {:error, msg} ->
        IO.puts "ERROR: #{msg}"
        terminate(node, request_pid, request_variables, variables)
    end
  end

  def terminate(node, request_pid, request_variables, variables) do
    terminate_node(node, request_pid, request_variables, variables)
  end

  # defaults
  def execute_node(_node, _request_pid, _request_variables, variables), do: {:ok, variables}
  def terminate_node(_node, _request_pid, _request_variables, _variables), do: :ok
end
