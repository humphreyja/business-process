defmodule Dashboard.Nodes.Computation.Base do
  use Dashboard.Nodes.Computation.Log

  # defaults
  def execute(_node, _request_pid, _req_variables, variables), do: {:ok, variables}
  def terminate(_node, _request_pid), do: :ok
end
