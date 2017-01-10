defmodule Dashboard.Nodes.Utils.Strings.Parser do
  @moduledoc """
  Taks a string with curly brace based code blocks and resolves the blocks based
  on a map of variables provided and from a series of functions provided by the
  Utils.Strings.Functions module
  """

  @r_group_content_match ~r/\{\{\s*.*?\s*\}\}/
  @r_group_match ~r/(\{\{\s*|\s*\}\})/

  @doc """
  Parses a string and resolves execution blocks.  Blocks are mustache wrapped.
  Will run functions with params as defined in the Strings.Functions module.

  iex> Dashboard.Nodes.Utils.Strings.Parser.execute_string("Hello {{ name }}, my name is {{ computer.name }}.  I am from {{ computer.city }}, {{ abbreviate(computer.state) }}.", %{"name" => "Joe", "computer" => %{"name" => "Siri", "city" => "Fargo", "state" => "North Dakota"}})
  "Hello Joe, my name is Siri.  I am from Fargo, ND."
  """
  @spec execute_string(String.t, Map.t) :: String.t | {:error, String.t}
  def execute_string(string, %{} = variables) when is_binary(string) do
    case parse_string(string) do
      [] -> string
      code_blocks -> execute_code_blocks(code_blocks, string, variables)
    end
  end

  @doc """
  Runs code not wrapped in a block.
  Will run functions with params as defined in the Strings.Functions module.

  iex> Dashboard.Nodes.Utils.Strings.Parser.execute_code("abbreviate(computer.state)", %{"computer" => %{"name" => "Siri", "city" => "Fargo", "state" => "North Dakota"}})
  {:ok, "ND"}
  """
  @spec execute_code(String.t, Map.t) :: {:ok, String.t} | {:ok, List.t} | {:error, String.t}
  def execute_code(code, variables) do
    with {:ok, tokens} <- fetch_tokens(code),
         {:ok, ast} <- fetch_ast(tokens),
    do: resolve_code(ast, variables)
  end

  # Executes each block {{ }} of code, then replaces that block with the result.  If there
  # are more than one of the same code blocks, it will only execute the code once and replace all
  # of the matching blocks
  defp execute_code_blocks([], string, _variables), do: string
  defp execute_code_blocks([code_block| rest], string, variables) do
    if String.contains?(string, code_block) do
      case execute_code(trim_braces(code_block), variables) do
        {:error, _msg} = err -> err
        {:ok, code_result} -> execute_code_blocks(rest, String.replace(string, code_block, fetch_code_result(code_result)), variables)
      end
    else
      execute_code_blocks(rest, string, variables)
    end
  end

  defp fetch_code_result(result) when is_list(result), do: "#{Enum.join(result, ", ")}"
  defp fetch_code_result(result), do: "#{result}"

  defp fetch_tokens(code) do
    case :lexer.string(String.to_char_list(code)) do
      {:ok, tokens, _} -> {:ok, tokens}
      {:error, {_, _, {:illegal, char}}, _} -> {:error, "Invalid character: #{char}"}
    end
  end

  defp fetch_ast(tokens) do
    case :parser.parse(tokens) do
      {:ok, ast} -> {:ok, ast}
      {:error, {_, _, message}} -> {:error, Enum.join(message, "")}
    end
  end

  defp resolve_code([], _variables), do: {:ok, []}
  defp resolve_code([code | rest], variables) do
    with {:ok, resolved_code} <- resolve_code(code, variables),
         {:ok, resolved_rest} <- resolve_code(rest, variables),
    do: {:ok, [resolved_code] ++ resolved_rest}
  end
  defp resolve_code(%{type: :function, name: name, params: params}, variables) do
    with {:ok, resolved_params} <- resolve_code(params, variables),
         {:ok, resolved_function} <- Dashboard.Nodes.Utils.Strings.Functions.execute_function(to_s(name), resolved_params),
    do: {:ok, resolved_function}
  end

  defp resolve_code(%{type: :list, values: values}, variables) do
    resolve_code(values, variables)
  end

  defp resolve_code(%{type: :integer, value: value}, _variables) do
    case Integer.parse(to_s(value)) do
     :error -> {:error, "Not a valid integer: #{value}"}
     {number, _extra} -> {:ok, number}
    end
  end
  defp resolve_code(%{type: :float, integer: integer, decimal: decimal}, _variables) do
    case Float.parse("#{integer}.#{decimal}") do
      :error -> {:error, "Not a valid decimal: #{integer}.#{decimal}"}
      {number, _extra} -> {:ok, number}
    end
  end
  defp resolve_code(%{type: :boolean, value: true}, _variables), do: {:ok, true}
  defp resolve_code(%{type: :boolean, value: false}, _variables), do: {:ok, false}
  defp resolve_code(%{type: :string, value: value}, _variables) do
    {:ok, String.replace(to_s(value), "\"", "")}
  end
  defp resolve_code(%{type: :symbol, value: value}, _variables), do: {:ok, to_s(value)}

  defp resolve_code(%{type: :variable} = variable, variables) do
    fetch_variable(variable, variables)
  end

  defp fetch_variable(%{name: name, nested: nested}, variables) do
    case Map.fetch(variables, to_s(name)) do
      {:ok, variable} -> fetch_variable(nested, variable)
      :error -> {:error, "Undefined variable: #{inspect name} in #{inspect variables}"}
    end
  end

  defp fetch_variable(%{name: name}, variables) do
    case Map.fetch(variables, to_s(name)) do
      {:ok, variable} -> {:ok, variable}
      :error -> {:error, "Undefined variable: #{inspect name} in #{inspect variables}"}
    end
  end

  defp to_s(binary), do: "#{binary}"

  # Gets a list of segments {{ some_var }} from a string
  # Returned in format: ["{{ some_var }}", ...]
  defp parse_string(string) do
    Regex.scan(@r_group_content_match, string)|> List.flatten
  end

  # Removes {{ }} from around the variable
  defp trim_braces(block) do
    String.replace(block, @r_group_match, "")
  end
end
