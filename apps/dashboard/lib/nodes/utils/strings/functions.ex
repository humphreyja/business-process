defmodule Dashboard.Nodes.Utils.Strings.Functions do
  def execute_function(_, {:error, msg}), do: {:error, msg}
  def execute_function("abbreviate", [arg1]) do
    with :error <- Map.fetch(Dashboard.Nodes.Utils.Mappings.States.data, String.downcase(arg1)),
        do: {:ok, arg1}
  end

  def execute_function("abbreviate", [arg1, ":state"]) do
    case Map.fetch(Dashboard.Nodes.Utils.Mappings.States.data, String.downcase(arg1)) do
      :error -> {:ok, arg1}
      {:ok, value} -> {:ok, value}
    end
  end

  def execute_function(unknown_func_name, _params), do: {:error, "Undefined function: #{inspect unknown_func_name}"}
end
