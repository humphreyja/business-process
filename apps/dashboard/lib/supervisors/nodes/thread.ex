defmodule Dashboard.Supervisors.Nodes.Thread do
  use Supervisor

  @name Node.Thread.Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def init(:ok) do
    children = [
      worker(Dashboard.Nodes.Thread, [], restart: :transient) # start a response process and kill after (restart if crash)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end

  def start_thread(conn) do
    {:ok, pid} = Supervisor.start_child(__MODULE__, [conn])
    Dashboard.Nodes.Thread.execute(pid)
    {:ok, pid}
  end

  def stop_thread(thread) do
    Supervisor.terminate_child(__MODULE__, thread)
  end
end
