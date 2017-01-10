defmodule Blackboard.NodeEnpointController do
  use Blackboard.Web, :controller

  def receive(conn, params) do
    conn = case Repo.get_by(Blackboard.RecvNode, uuid: Map.get(params, "id")) do
      %Blackboard.RecvNode{name: name} -> conn |> assign(:variables, %{"#{name}-endpoint" => Map.drop(conn.params, ["id"])}) |> send_resp(200, "Done")
      _ -> conn |> send_resp(404, "Done") |> halt
    end

    IO.inspect conn.assigns
    halt(conn)
  end
end
