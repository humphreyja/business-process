defmodule Dashboard.Nodes.Computation.Log do
  require Logger

  defmacro __using__(_) do
    quote do
      def execute(%{name: "Log"} = node, request_pid, req_variables, variables) do
        Dashboard.Nodes.Computation.Log.execute(node, request_pid, req_variables, variables)
      end

      def terminate(%{name: "Log"} = node, request_pid) do
        Dashboard.Nodes.Computation.Log.terminate(node, request_pid)
      end
    end
  end

  def execute(%{name: "Log"} = node, request_pid, req_variables, variables) do
    Logger.info fetch_default_message(node)
    {:ok, variables}
  end

  def terminate(%{name: "Log"} = node, request_pid) do
    :ok
  end

  defp fetch_default_message(%{message: message}), do: message
  defp fetch_default_message(node), do: "Empty Log Request"
end
