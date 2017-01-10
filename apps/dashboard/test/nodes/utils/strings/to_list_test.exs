defmodule Dashboard.Test.Nodes.Utils.Strings.ToListTest do
  use ExUnit.Case, async: true
  alias Dashboard.Nodes.Utils.Strings.ToList

  doctest ToList

  test "to list returns a list" do
    string = ToList.parse("[test, me]")
    assert string == ["test", "me"]
  end
  test "to list returns a single list" do
    string = ToList.parse("[test]")
    assert string == ["test"]
  end

  test "to list returns a nested list" do
    string = ToList.parse("[test, me, [nested, obj]]")
    assert string == ["test", "me", ["nested", "obj"]]
  end

  test "to list returns a random nested list" do
    string = ToList.parse("[test, [me, [deeper]], [nested, obj], last]")
    assert string == ["test", ["me", ["deeper"]], ["nested", "obj"], "last"]
  end

  test "to list returns input if not a list" do
    string = ToList.parse("test, thing")
    assert string == "test, thing"
  end
end
