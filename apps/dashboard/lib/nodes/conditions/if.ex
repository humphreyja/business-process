defmodule Dashboard.Nodes.Conditions.If do
  @moduledoc """
  Determines the next step based on a comparison between a left hand side and a right hand side.
  Supported operators:
  ==, !=, >, >=, <, <=, in

  Also by providing a serializer type, you can make comparisons stronger, like comparing
  two numbers that are different types, otherwise everything is compared as a string.
  Look at the Utils.Strings.Serializer module for the types available

  """
  defmacro __using__(_) do
    quote do
      def execute(%{lhs: _lhs, rhs: _rhs, operator: _operator} = node, parent_pid, req_variables, variables) do
        Dashboard.Nodes.Conditions.If.execute(node, parent_pid, req_variables, variables)
      end

      def terminate(%{lhs: _lhs, rhs: _rhs, operator: _operator}, _request_pid) do
        :ok
      end
    end
  end

  @doc """
  Compares the left and right hand side values by the condition
  By providing a serializer, it will convert the left and right hand sides to that
  type allowing for better comparisons.
  """
  def execute(%{lhs: lhs, rhs: rhs, operator: operator, next_true: next_true, next_false: next_false} = node, _parent_pid, req_variables, variables) do
    combined_variables = Map.merge(req_variables, variables)
    with {:ok, resolved_lhs} <- fetch_value(lhs, combined_variables, node[:serialize]),
         {:ok, resolved_rhs} <- fetch_value(rhs, combined_variables, node[:serialize]),
         next <- eval_expression(resolved_lhs, resolved_rhs, operator, next_true, next_false),
    do: {:ok, variables, next}
  end

  # Resolve the variables in the string and serialize the result
  defp fetch_value(string, variables, serialize) do
    case Dashboard.Nodes.Utils.Strings.Parser.execute_string(string, variables) do
      {:error, _msg} = err -> err
      resolved_string ->
        case Dashboard.Nodes.Utils.Strings.Serializer.serialize_value(resolved_string, serialize, false) do
          {:error, _msg} = err -> err
          serialized_string -> {:ok, serialized_string}
        end
    end
  end

  # Based on the condition, return either the true of false nodes
  defp eval_expression(lhs, rhs, "==", next_true, next_false), do: if lhs == rhs, do: next_true, else: next_false
  defp eval_expression(lhs, rhs, "!=", next_true, next_false), do: if lhs != rhs, do: next_true, else: next_false
  defp eval_expression(lhs, rhs, ">", next_true, next_false), do: if lhs > rhs, do: next_true, else: next_false
  defp eval_expression(lhs, rhs, ">=", next_true, next_false), do: if lhs >= rhs, do: next_true, else: next_false
  defp eval_expression(lhs, rhs, "<", next_true, next_false), do: if lhs < rhs, do: next_true, else: next_false
  defp eval_expression(lhs, rhs, "<=", next_true, next_false), do: if lhs <= rhs, do: next_true, else: next_false
  defp eval_expression(lhs, rhs, "in", next_true, next_false) when is_list(lhs), do: if Enum.member?(lhs, rhs), do: next_true, else: next_false
  defp eval_expression(lhs, rhs, "in", next_true, next_false) when is_list(rhs), do: if Enum.member?(rhs, lhs), do: next_true, else: next_false
  defp eval_expression(_lhs, _rhs, _unknown, next_true, _next_false), do: next_true
end
