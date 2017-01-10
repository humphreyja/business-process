defmodule WebPortal.Api.Trigger do
 use WebPortal.Node
 @moduledoc """
 NODE -> has many child nodes, possible parent nodes.

 Trigger.next(data) -> childnodes.each(&:visit(data))
 """
end
