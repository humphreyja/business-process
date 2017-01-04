defmodule Dashboard.Nodes.Computation.Catch do
  defmacro __using__(_) do
    quote do
      # Capture Executes
      def execute_node(%{type: "Computation"} = node, request_pid, req_variables, variables) do
        Dashboard.Nodes.Computation.Base.execute(node, request_pid, req_variables, variables)
      end

      # Capture terminate
      def terminate_node(%{type: "Computation"} = node, request_pid, _req_variables, _variables) do
        Dashboard.Nodes.Computation.Base.terminate(node, request_pid)
      end
    end
  end
end
