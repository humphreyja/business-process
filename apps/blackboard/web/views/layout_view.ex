defmodule Blackboard.LayoutView do
  use Blackboard.Web, :view

  def body_class(%{private: %{phoenix_controller: controller, phoenix_action: action}}) do
    module_class = Macro.underscore(controller)
    |> String.replace("_controller", "")
    |> String.replace("/", "--")

    "#{module_class} #{action}"
  end
end
