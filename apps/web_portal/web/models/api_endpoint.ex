defmodule WebPortal.APIEndpoint do
  use WebPortal.Web, :model
  @url_scrub_regex ~r/{{\s*(?<variable>[a-zA-Z0-9_-]*)\s*}}/i

  schema "api_endpoint" do
    field :name, :string
    field :description, :string
    field :url, :string
    field :method, :string
    field :headers, :string
    field :auth, :boolean

    belongs_to :api_service, WebPortal.APIService

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> validate_required([])
  end

  @doc """
  Generates a url from the url provided and params

  Valid
  iex > generate_url("https://www.google.com/{{ user_id }}/events", %{user_id: "axk23no3lkd02n1", start: "2016-01-01", end: "2016-12-31"})
  {:ok, "https://www.google.com/axk23no3lkd02n1/events?start=2016-01-01&end=2016-12-31"}

  Invalid
  iex > generate_url("https://www.google.com/{{ user_id }}", %{start: "2016-01-01"})
  {:error, "user_id is a required parameter"}
  """
  def generate_url(url, url_params), do: generate_url(url, url_params, "GET")
  def generate_url(url, url_params, "GET") do
    case resolve_url(url, url_params) do
      {:ok, m_url, m_params} ->
        {:ok, "#{m_url}#{resolve_params(Enum.to_list m_params)}"}
      {:error, msg} -> {:error, msg}
    end

  end
  def generate_url(url, url_params, method \\ "GET"), do: resolve_url(url, url_params)

  defp resolve_params([]), do: ""
  defp resolve_params(url_params) do
    "?#{Enum.join(Enum.map(url_params, fn({k,v}) -> "#{k}=#{v}" end), "&")}"
  end

  defp resolve_url(url, url_params) do
    case Regex.named_captures(@url_scrub_regex, url) do
      %{"variable" => variable_name} ->
        case assign_variable(variable_name, url, url_params) do
          {:error, msg} -> {:error, msg}
          {m_url, m_params} -> resolve_url(m_url, m_params)
        end
      _nil -> {:ok, url, url_params}
    end
  end

  defp assign_variable(variable, url, url_params) do
    case Map.pop(url_params, variable) do
      {nil, params} -> {:error, "Param not provided for: #{variable}"}
      {param, params} -> {Regex.replace(@url_scrub_regex, url, param, [global: false]), params}
    end
  end

  def request(endpoint, data) do
    case generate_url(endpoint.url, data, endpoint.method) do
      {:ok, url, data} ->
        _request(url, endpoint.method, endpoint.headers, data)
      {:ok, url} ->
        _request(url, endpoint.method, endpoint.headers, %{})
      {:error, msg} -> msg
    end
  end

  @doc """
  Send request to url using correct method, including headers and data.
  return json (xml parsing needed in the future) or :ok
  """
  defp _request(url, nil, headers, data), do: _request(url, "GET", headers, data)
  defp _request(url, "GET", _headers, _data) do
    IO.puts("REQUEST TO: #{ inspect url }")
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Poison.decode! body}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "Could not locate #{inspect url}"}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "Error: #{inspect reason}"}
    end
  end
  defp _request(url, "POST", headers, data), do: :ok
  defp _request(url, "PUT", headers, data), do: :ok
  defp _request(url, "PATCH", headers, data), do: :ok
  defp _request(url, "DELETE", headers, data), do: :ok
end
