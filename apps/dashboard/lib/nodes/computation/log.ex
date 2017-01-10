defmodule Dashboard.Nodes.Computation.Log do
  require Logger

  defmacro __using__(_) do
    quote do
      def execute(%{name: "Log"} = node, parent_pid, req_variables, variables) do
        Dashboard.Nodes.Computation.Log.execute(node, parent_pid, req_variables, variables)
      end

      def terminate(%{name: "Log"} = node, parent_pid) do
        :ok
      end
    end
  end

  def execute(%{name: "Log", next: next} = node, parent_pid, req_variables, variables) do
    Logger.info fetch_default_message(node)
    {:ok, variables, next}
  end

  defp fetch_default_message(%{message: message}), do: message
  defp fetch_default_message(node), do: "Empty Log Request"
end
