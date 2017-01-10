defmodule Dashboard.Nodes.Utils.Strings.ToList do
  @moduledoc """
  Converts a string version of a list into an actual list.
  """

  @start_list "["
  @end_list ~r/\]/
  @separator ~r/,\s*/

  @spec parse(String.t) :: String.t | List.t
  def parse(string) do
    if valid_list?(string) do
      List.first(parse_list(split_string(string), [], []))
    else
      string
    end
  end

  defp split_string(string) do
    String.split(string, @separator)
  end

  defp valid_list?(string) do
    Regex.match?(~r/^\s*\[.*\]$/, string)
  end

  def parse_list([], working_list, _nested_lists), do: working_list
  def parse_list([@start_list <> item|rest], working_list, nested_lists) do
    parse_list([item] ++ rest, [], [working_list] ++ nested_lists)
  end

  def parse_list([item|rest], working_list, nested_lists) do
    {working_list, nested_lists} = cond do
      Regex.match?(@end_list, item) ->
        pop_list(
          nested_lists,
          working_list ++ [String.replace(item, @end_list, "")],
          Regex.scan(@end_list, item) |> List.flatten |> Enum.count
        )
      true ->
        {working_list ++ [item], nested_lists}
    end
    parse_list(rest, working_list, nested_lists)
  end

  defp pop_list(nest, list, 0), do: {list, nest}
  defp pop_list([nest | rest], list, count) do
    pop_list(rest, nest ++ [list], count - 1)
  end
end
