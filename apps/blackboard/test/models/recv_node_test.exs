defmodule Blackboard.RecvNodeTest do
  use Blackboard.ModelCase

  alias Blackboard.RecvNode

  @valid_attrs %{name: "some content", request_url: "some content", uuid: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = RecvNode.changeset(%RecvNode{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = RecvNode.changeset(%RecvNode{}, @invalid_attrs)
    refute changeset.valid?
  end
end
