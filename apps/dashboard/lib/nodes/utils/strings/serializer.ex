defmodule Dashboard.Nodes.Utils.Strings.Serializer do
  @moduledoc """
  Converts a string value into a type or a list of types.

  Available types
  ---------------
  integer
  decimal
  phone_number
  email


  """
  @spec serialize_value(String.t, String.t, Boolean.t) :: String.t | {:error, String.t}
  def serialize_value(value, type, error \\ true) do
    serialize(Dashboard.Nodes.Utils.Strings.ToList.parse(value), type, error)
  end

  defp serialize([], _type, _error), do: []
  defp serialize([item|rest], type, error) do
    [serialize(item, type, error)] ++ serialize(rest, type, error)
  end

  defp serialize(string, "integer", error) do
    case Integer.parse(string) do
      :error -> handle_error({:error, "Not a valid integer"}, string, error)
      {number, _extra} -> number
    end
  end

  defp serialize(string, "decimal", error) do
    case Float.parse(string) do
      :error -> handle_error({:error, "Not a valid decimal"}, string, error)
      {number, _extra} -> number
    end
  end

  defp serialize(string, "phone_number", error) do
    case Regex.named_captures(~r/(?<number>(\+?(?<country>(\d{1,2}))\s?)?(\(?(?<region>(\d{3}))\)?(\s|-|\.)?)((?<first>(\d{3}))(\s|-|\.)?)((?<last>(\d{4}))))/i, string) do
      nil -> handle_error({:error, "Not a valid phone number"}, string, error)
      %{"country" => country, "first" => first, "last" => last, "region" => region, "number" => _n} ->
        {number, _extra} = Integer.parse("#{aux_phone_number_country(country)}#{region}#{first}#{last}")
        number
    end
  end

  defp serialize(string, "email", error) do
    case Regex.named_captures(~r/(?<email>\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b)/i, string) do
      nil -> handle_error({:error, "Not a valid email"}, string, error)
      %{"email" => email} -> email
    end
  end

  defp serialize(string, _unknown, _err) do
    string
  end

  defp handle_error(err, _string, true), do: err
  defp handle_error(_err, string, false), do: string
  defp aux_phone_number_country(""), do: "1"
  defp aux_phone_number_country(n), do: n
end
