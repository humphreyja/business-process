defmodule Dashboard.Nodes.Actions.Post do
  defmacro __using__(_) do
    quote do
      def execute(%{method: :post} = node, parent_pid, req_variables, variables) do
        Dashboard.Nodes.Actions.Post.execute(node, parent_pid, req_variables, variables)
      end

      def terminate(%{method: :post}, _parent_pid) do
        :ok
      end
    end
  end

  def execute(%{method: :post, url: url, data: data, content_type: content_type, next: next}, _parent_pid, req_variables, variables) do
    all_variables = Map.merge(req_variables, variables)

    with {:ok, body} <- fetch_data(Map.to_list(data), all_variables),
         {:ok, encoded_body} <- encode_body(body, content_type),
         :ok <- IO.puts("SENDING POST: #{inspect encoded_body}"),
         {:ok, response} <- HTTPoison.post(url, encoded_body, [{"Content-Type", content_type}]),
         :ok <- IO.puts("RESPONSE: #{inspect response}"),
    do: {:ok, variables, next}
  end

  defp encode_body(data, "application/json") do
    Poison.encode(data)
  end

  defp fetch_data([], _variables), do: {:ok, %{}}
  defp fetch_data([{key, %{} = value}| rest], variables) do
    with {:ok, data} <- fetch_data(Map.to_list(value), variables),
         {:ok, rest_data} <- fetch_data(rest, variables),
    do: {:ok, Map.merge(rest_data, %{key => data})}
  end
  defp fetch_data([{key, value}| rest], variables) do
    with {:ok, data} <- fetch_string(value, variables),
         {:ok, data_map} <- fetch_data(rest, variables),
    do: {:ok, Map.merge(data_map, %{key => data})}
  end

  defp fetch_string(string, variables) do
    case Dashboard.Nodes.Utils.Strings.Parser.execute_string(string, variables) do
      {:error, _msg} = err -> err
      value -> {:ok, value}
    end
  end
end
