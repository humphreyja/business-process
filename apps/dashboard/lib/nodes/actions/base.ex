defmodule Dashboard.Nodes.Actions.Base do
  use Dashboard.Nodes.Actions.Post

  # defaults
  def execute(_node, _parent_pid, _req_variables, variables), do: {:ok, variables, []}
  def terminate(_node, _parent_pid), do: :ok
end
