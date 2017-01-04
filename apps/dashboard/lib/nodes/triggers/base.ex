defmodule Dashboard.Nodes.Triggers.Base do
  @node_type "Trigger"
  @default_body "OK"
  @default_status 200
  @default_timeout 0

  def execute(node, request_pid, req_variables, variables) do
    set_response(node, request_pid)
    case compute(node, req_variables, variables) do
      {:ok, variables} ->
        {:ok, variables}
      :error ->
        {:error, variables}
    end
  end

  def terminate(%{type: @node_type} = node, request_pid) do
    send(request_pid, {:default, fetch_default_status(node), fetch_default_body(node), 0})
  end



  defp set_response(%{type: @node_type} = node, request_pid) do
    send(request_pid, {:default, fetch_default_status(node), fetch_default_body(node), fetch_timeout(node)})
  end

  defp compute(%{type: @node_type} = node, req_variables, variables) do
    {:ok, variables}
  end

  ### DEFAULTS ###
  defp fetch_default_body(%{type: @node_type, default_body: body}), do: body
  defp fetch_default_body(%{type: @node_type}), do: @default_body

  defp fetch_default_status(%{type: @node_type, default_status: status}), do: status
  defp fetch_default_status(%{type: @node_type}), do: @default_status

  defp fetch_timeout(%{type: @node_type, timeout: timeout}), do: timeout
  defp fetch_timeout(%{type: @node_type}), do: @default_timeout
end
