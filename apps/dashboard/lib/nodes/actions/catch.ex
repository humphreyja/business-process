defmodule Dashboard.Nodes.Actions.Catch do
  defmacro __using__(_) do
    quote do
      # Capture Executes
      def execute_node(%{type: "Action"} = node, parent_pid, req_variables, variables) do
        Dashboard.Nodes.Actions.Base.execute(node, parent_pid, req_variables, variables)
      end

      # Capture terminate
      def terminate_node(%{type: "Action"} = node, parent_pid, _req_variables, _variables) do
        Dashboard.Nodes.Actions.Base.terminate(node, parent_pid)
      end
    end
  end
end
