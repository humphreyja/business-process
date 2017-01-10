defmodule Dashboard.Nodes.Catch do
  use Dashboard.Nodes.Triggers.Catch
  use Dashboard.Nodes.Computation.Catch
  use Dashboard.Nodes.Conditions.Catch
  use Dashboard.Nodes.Actions.Catch

  def execute(node, parent_pid, request_variables, variables) do
    case execute_node(node, parent_pid, request_variables, variables) do
      {:ok, new_variables, next} ->
        Dashboard.Nodes.Thread.next(node, parent_pid, request_variables, new_variables, next)
      {:error, msg} ->
        IO.puts "FAIL: #{inspect msg}"
        terminate(node, parent_pid, request_variables, variables)
    end
  end

  def terminate(node, parent_pid, request_variables, variables) do

    terminate_node(node, parent_pid, request_variables, variables)
  end

  # defaults
  def execute_node(_node, _parent_pid, _request_variables, variables), do: {:ok, variables, []}
  def terminate_node(_node, _parent_pid, _request_variables, _variables), do: :ok
end
