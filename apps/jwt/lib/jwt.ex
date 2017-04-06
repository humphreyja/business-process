defmodule JWT do
  import Joken

  @type token :: Map.t
  @type client_secret :: String.t
  @type jwt_token :: String.t

  @spec generate(token, client_secret) :: jwt_token
  def generate(token, client_secret) do
    secret_base = Application.get_env(:jwt, :secret_base, "")
    secret = "#{secret_base}#{client_secret}"

    token
    |> token
    |> with_signer(hs256(secret))
    |> sign
    |> get_compact
  end

  @spec decrypt(jwt_token, client_secret) :: {:ok, token} | {:error, Joken.Token.t}
  def decrypt(jwt, client_secret) do
    case aux_decrypt(jwt, client_secret) do
      %Joken.Token{claims: claims, error: nil, errors: nil} -> {:ok, claims}
      err -> {:error, err}
    end
  end

  defp aux_decrypt(jwt, client_secret) do
    secret_base = Application.get_env(:jwt, :secret_base, "")
    secret = "#{secret_base}#{client_secret}"

    jwt
    |> token
    |> with_signer(hs256(secret))
    |> verify
  end

  def valid_token(jwt_token, client_secret \\ "") do
    case JWT.decrypt(jwt_token, Application.get_env(:jwt, :client_secret, client_secret)) do
      {:ok, claims} ->
        if aux_timestamp_check_token(claims) do
          {:ok, claims}
        else
          {:error, "Token Expired"}
        end
      {:error, error} -> {:error, error}
    end
  end

  defp aux_timestamp_check_token(%{"sent_at" => unixts}) do
    (:os.system_time(:seconds) - unixts) < Application.get_env(:jwt, :token_expire_in, 60)
  end
  defp aux_timestamp_check_token(_), do: false
end
