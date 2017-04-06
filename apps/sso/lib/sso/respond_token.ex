defmodule SSO.RespondToken do
  import Plug.Conn
  import Phoenix.Controller
  import Logger
  def try_respond_with_token(conn, token, method) do
    token = Map.put(token, :sent_at, :os.system_time(:seconds))
    result = with {:ok, client_key} <- get_client_key(conn),
         {:ok, client} <- fetch_client(client_key),
         jwt_token <- JWT.generate(token, client.secret),
         decrypted <- JWT.decrypt(jwt_token, client.secret)
    do
      conn
      |> delete_session(:client_key)
      |> response_redirect(client, jwt_token, method)
      |> halt
    end
    return_connection(result, conn)
  end

  defp return_connection(%Plug.Conn{} = conn, _), do: {:ok, conn}
  defp return_connection(_, conn), do: {:error, conn}

  defp response_redirect(conn, client, jwt_token, :sign_out) do
    redirect(conn, external: redirect_client(client.sign_out_redirect_url, jwt_token))
  end

  defp response_redirect(conn, client, jwt_token, _) do
    redirect(conn, external: redirect_client(client.sign_in_redirect_url, jwt_token))
  end


  defp fetch_client(client_key) do
    case SSO.Repo.get_by(SSO.Client, client_key: client_key) do
      nil -> nil
      client -> {:ok, client}
    end
  end

  defp get_client_key(%{params: %{"client_key" => client_key}}), do: {:ok, client_key}
  defp get_client_key(conn) do
    case get_session(conn, :client_key) do
      nil -> nil
      key -> {:ok, key}
    end
  end

  defp redirect_client(url, token) do
    var_string = "token=#{token}"
    if String.contains?(url, "?") do
      "#{url}&#{var_string}"
    else
      "#{url}/?#{var_string}"
    end
  end
end
