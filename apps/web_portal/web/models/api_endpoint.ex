defmodule WebPortal.APIEndpoint do
  use WebPortal.Web, :model
  @url_scrub_regex ~r/{{\s*(?<variable>[a-zA-Z0-9_-]*)\s*}}/i

  schema "api_endpoint" do
    field :name, :string
    field :description, :string
    field :url, :string
    field :method, :string
    field :headers, :string

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
  def generate_url(url, url_params) do
    # TODO: Check for {{ variable }} in url and resolve it to variable in url_params
    {m_url, m_params} = resolve_url(url, url_params)
    "#{m_url}#{resolve_params(Enum.to_list m_params)}"
  end

  defp resolve_params([]), do: ""
  defp resolve_params(url_params) do
    "?#{Enum.join(Enum.map(url_params, fn({k,v}) -> "#{k}=#{v}" end), "&")}"
  end

  defp resolve_url(url, url_params) do
    case Regex.named_captures(@url_scrub_regex, url) do
      %{"variable" => variable_name} ->
                      {m_url, m_params} = assign_variable(variable_name, url, url_params)
                      resolve_url(m_url, m_params)
      _nil -> {url, url_params}
    end
  end

  defp assign_variable(variable, url, url_params) do
    case Map.pop(url_params, variable) do
      {nil, params} -> {url, params}
      {param, params} -> {Regex.replace(@url_scrub_regex, url, param, [global: false]), params}
      _err -> {url, url_params}
    end
  end

  @doc """
  Send request to url using correct method, including headers and data.
  return json (xml parsing needed in the future) or :ok
  """
  def request(url, "GET", headers, data), do: :ok
  def request(url, "POST", headers, data), do: :ok
  def request(url, "PUT", headers, data), do: :ok
  def request(url, "PATCH", headers, data), do: :ok
  def request(url, "DELETE", headers, data), do: :ok
end
