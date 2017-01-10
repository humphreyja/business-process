defmodule Dashboard.Nodes.Utils.Strings.Functions do
  @moduledoc """
  Basic functions to be executed on a string.

  Available Functions
  -------------------
  abbreviate
  reverse
  format
  """

  def execute_function(_, {:error, msg}), do: {:error, msg}

  @doc """
  Abbreviate [arg] is a generic version of the function calling every data source
  to find an abbreviation for the provided string.

  NOTE: If you know the type of the string before calling the function, consider providing
  it a scope for the second argument.
  """
  def execute_function("abbreviate", [string]) do
    with :error <- Map.fetch(Dashboard.Nodes.Utils.Mappings.States.data, String.downcase(string)),
        do: {:ok, string}
  end

  @doc """
  Abbreviate for state abbreviations.
  """
  def execute_function("abbreviate", [string, ":state"]) do
    case Map.fetch(Dashboard.Nodes.Utils.Mappings.States.data, String.downcase(string)) do
      :error -> {:ok, string}
      {:ok, value} -> {:ok, value}
    end
  end

  def execute_function("reverse", [string]) when is_binary(string) do
    {:ok, String.reverse(string)}
  end

  def execute_function("reverse", [list]) when is_list(list) do
    {:ok, Enum.reverse(list)}
  end

  def execute_function("reverse", [number]) when is_number(number) do
    {:ok, String.reverse("#{number}")}
  end

  def execute_function("join", [list, char]) when is_list(list) do
    {:ok, Enum.join(list, char)}
  end

  def execute_function("titleize", [string]) when is_binary(string) do
    {:ok, String.capitalize(string)}
  end

  @doc """
  Format - phone_number
  """
  def execute_function("format", [string, format, ":phone_number", delimiter]) do
    format = format
    |> String.replace("\"", "")
    |> String.graphemes
    |> Enum.reverse

    string = "#{Dashboard.Nodes.Utils.Strings.Serializer.serialize_value(string, "phone_number", false)}"
    |> String.graphemes
    |> Enum.reverse

    delimiter = String.replace(delimiter, "\"", "")

    {:ok, String.reverse(aux_format_phone_number(string, format, delimiter))}
  end

  def execute_function("format", [string, format, ":phone_number"]) do
    execute_function("format", [string, format, ":phone_number", "#"])
  end

  def execute_function(unknown_func_name, _params), do: {:error, "Undefined function: #{inspect unknown_func_name}"}

  defp aux_format_phone_number(_, [], _), do: ""
  defp aux_format_phone_number([], [char|rest], delimiter) do
    "#{char}#{aux_format_phone_number([], rest, delimiter)}"
  end
  defp aux_format_phone_number([number|numbers], [char|rest], delimiter) do
    if char == delimiter do
      "#{number}#{aux_format_phone_number(numbers, rest, delimiter)}"
    else
      "#{char}#{aux_format_phone_number([number] ++ numbers, rest, delimiter)}"
    end

  end
end
