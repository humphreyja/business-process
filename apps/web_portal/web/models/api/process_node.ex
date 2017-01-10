defmodule WebPortal.Api.ProcessNode do
  use WebPortal.Node
  @moduledoc """
  Is a type of process node.

  visit(data) -> childrenNodes.map(&:visit(data))

  visit may receive data from multiple nodes, need to wait for async to catch up.
  """
end
