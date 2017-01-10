defmodule Dashboard.Nodes.Triggers.Base do
  @default_body "OK"
  @default_status 200
  @default_content_type "text/plain"
  @default_timeout 0

  def execute(%{next: next} = node, parent_pid, req_variables, variables) do
    set_response(node, parent_pid)
    case compute(node, req_variables, variables) do
      {:ok, variables} ->
        IO.puts "DONE: Vars: #{inspect variables}"
        {:ok, variables, next}
      {:error, msg} -> {:error, msg}
    end
  end

  def terminate(node, parent_pid) do
    send(parent_pid, {:default, fetch_default_status(node), fetch_default_body(node), fetch_default_content_type(node), 0})
  end

  defp set_response(node, parent_pid) do
    send(parent_pid, {:default, fetch_default_status(node), fetch_default_body(node), fetch_default_content_type(node), fetch_timeout(node)})
  end

  defp compute(%{expose: expose}, req_variables, variables) do
    case expose_variables(Map.to_list(expose), req_variables) do
      {:error, msg} -> {:error, msg}
      {:ok, vars} -> {:ok, Enum.into(vars, %{}) |> Map.merge(variables)}
    end
  end

  defp expose_variables([], _req_variables), do: {:ok, %{}}
  defp expose_variables([{key, val} | rest], req_variables) do
    with {:ok, nested_val} <- expose_variables(val, req_variables),
         {:ok, rest_val} <- expose_variables(rest, req_variables),
    do: {:ok, Map.put(rest_val, key, nested_val)}
  end
  defp expose_variables(val, req_variables) when is_map(val), do: expose_variables(Map.to_list(val), req_variables)
  defp expose_variables(val, _req_variables) when is_number(val), do: {:ok, val}

  defp expose_variables(val, req_variables) when is_binary(val) do
    case Dashboard.Nodes.Utils.Strings.Parser.execute_string(val, req_variables) do
      {:error, msg} = err -> err
      resolved_string -> {:ok, resolved_string}
    end
  end

  ### DEFAULTS ###
  defp fetch_default_body(%{default_body: body}), do: body
  defp fetch_default_body(%{}), do: @default_body

  defp fetch_default_status(%{default_status: status}), do: status
  defp fetch_default_status(%{}), do: @default_status

  defp fetch_default_content_type(%{default_content_type: content_type}), do: content_type
  defp fetch_default_content_type(%{}), do: @default_content_type

  defp fetch_timeout(%{timeout: timeout}), do: timeout
  defp fetch_timeout(%{}), do: @default_timeout
end
