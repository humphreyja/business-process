defmodule Dashboard.Test.Nodes.Utils.Strings.ParserTest do
  use ExUnit.Case, async: true
  alias Dashboard.Nodes.Utils.Strings.Parser

  doctest Parser

  test "parser returns same string" do
    string = Parser.execute_string("nothing in me", %{})
    assert string == "nothing in me"
  end

  test "parser resolves variable" do
    string = Parser.execute_string("name is {{ name }}", %{"name" => "John"})
    assert string == "name is John"
  end

  test "parser resolves nested variable" do
    string = Parser.execute_string("name is {{ user.name }}", %{"user" => %{"name" => "John"}})
    assert string == "name is John"
  end

  test "parser resolves function" do
    string = Parser.execute_string("abbr for state is {{ abbreviate(state) }}", %{"state" => "North Dakota"})
    assert string == "abbr for state is ND"
  end

  test "parser resolves function with different args" do
    string = Parser.execute_string("abbr for state is {{ abbreviate(state, :state) }}", %{"state" => "North Dakota"})
    assert string == "abbr for state is ND"
  end
end
