defmodule Dashboard.Nodes.Utils.Strings.Parser do

  @r_function_call ~r/^([a-z]*)\((.*?)\)$/i
  @r_variable ~r/^[a-z0-9_]{1,}(?:\.[a-z0-9_]{1,})*$/i
  @r_arg_list ~r/,\s*/
  @r_symbol_match ~r/\:[a-z][a-z0-9_]*/

  @r_group_content_match ~r/\{\{\s*.*?\s*\}\}/
  @r_group_match ~r/(\{\{\s*|\s*\}\})/

  @doc """
  Parses a string and resolves execution blocks.  Blocks are mustache wrapped.
  Will run functions with params as defined in the Strings.Functions module.

  iex> Dashboard.Nodes.Utils.Strings.Parser.execute_string("Hello {{ name }}, my name is {{ computer.name }}.  I am from {{ computer.city }}, {{ abbreviate(computer.state) }}.", %{"name" => "Joe", "computer" => %{"name" => "Siri", "city" => "Fargo", "state" => "North Dakota"}})
  "Hello Joe, my name is Siri.  I am from Fargo, ND."
  """
  def execute_string(string, %{} = variables) when is_binary(string) do
    case parse_string(string) do
      [] -> string
      code_blocks -> execute_code_blocks(code_blocks, string, variables)
    end
  end

  # Executes each block {{ }} of code, then replaces that block with the result.  If there
  # are more than one of the same code blocks, it will only execute the code once and replace all
  # of the matching blocks
  defp execute_code_blocks([], string, _variables), do: string
  defp execute_code_blocks([code_block| rest], string, variables) do
    if String.contains?(string, code_block) do
      case execute_code(trim_braces(code_block), variables) do
        {:error, _msg} = err -> err
        {:ok, code_result} -> execute_code_blocks(rest, String.replace(string, code_block, code_result), variables)
      end
    else
      execute_code_blocks(rest, string, variables)
    end
  end

  # Catches errors or joins the list of segments by a space
  defp execute_code(code, variables) do
    case execute_code_segment([code], variables) do
      {:error, _msg} = err -> err
      {:ok, value} -> {:ok, Enum.join(value, " ")}
    end
  end

  # Matches a segment into a specific type or returns an error
  defp execute_code_segment([], _variables), do: {:ok, []}
  defp execute_code_segment([code|rest], variables) do
    execution_result = cond do
      # Match Function Calls
      Regex.match?(@r_function_call, code) -> execute_code_segment_function(code, variables)

      # Match Variables
      Regex.match?(@r_variable, code) -> execute_code_segment_variable(String.split(code, "."), variables)

      # Match arg lists
      Regex.match?(@r_arg_list, code) -> execute_code_segment(String.split(code, @r_arg_list), variables)

      # Match symbols
      Regex.match?(@r_symbol_match, code) -> execute_code_segment_symbol(code)

      true -> {:error, "Invalid code: #{inspect code}"}
    end
    case fetch_execute_code_segment_result(execution_result) do
      {:error, _msg} = err -> err
      {:ok, value} ->
        case execute_code_segment(rest, variables) do
          {:error, _msg} = err -> err
          {:ok, rest_value} -> {:ok, value ++ rest_value}
        end
    end
  end

  # Matches the results to return either an error or an ok list
  defp fetch_execute_code_segment_result({:error, msg}), do: {:error, msg}
  defp fetch_execute_code_segment_result({:ok, value}) when is_list(value), do: {:ok, value}
  defp fetch_execute_code_segment_result({:ok, value}), do: {:ok, [value]}
  defp fetch_execute_code_segment_result(_value), do: {:ok, []}


  # Resolves the arguments of a function first (supports nested functions),
  #  then it searches the functions module for a matching function to run.
  defp execute_code_segment_function(segment, variables) do
    with [_m, func, params]       <- Regex.scan(@r_function_call, segment) |> List.flatten,
         {:ok, resolved_arg_list} <- execute_code_segment([params], variables),
         {:ok, resolved_function} <- Dashboard.Nodes.Utils.Strings.Functions.execute_function(func, resolved_arg_list),
    do: {:ok, resolved_function}
  end

  # Resolves a "symbol" to a string version of it (for garbage collection issues)
  defp execute_code_segment_symbol(segment), do: {:ok, String.trim(segment)}

  # Fetches the variable from a nested structure or returns an error
  defp execute_code_segment_variable([], variable), do: {:ok, variable}
  defp execute_code_segment_variable([segment | rest], variables) do
    case Map.fetch(variables, segment) do
      {:ok, variable} -> execute_code_segment_variable(rest, variable)
      :error -> {:error, "Undefined variable: #{inspect segment} in #{inspect variables}"}
    end
  end

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
