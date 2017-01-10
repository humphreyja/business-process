defmodule Dashboard.Test.Nodes.Utils.Strings.ParserTest do
  use ExUnit.Case, async: true
  alias Dashboard.Nodes.Utils.Strings.Parser

  doctest Parser

  test "parser returns same string" do
    string = Parser.execute_string("nothing in me", %{})
    assert string == "nothing in me"
  end

  test "parser returns a string" do
    string = Parser.execute_string("Here is a {{ \"string\" }}", %{})
    assert string == "Here is a string"
  end

  test "parser returns a symbol" do
    string = Parser.execute_string("Here is a {{ :symbol }}", %{})
    assert string == "Here is a :symbol"
  end

  test "parser returns a list of function calls" do
    string = Parser.execute_string("List: {{ [abbreviate(state), titleize(name)]}}", %{"name" => "jake", "state" => "minnesota"})
    assert string == "List: MN, Jake"
  end

  test "parser returns a joined list" do
    string = Parser.execute_string("{{ join([name, age], \", \") }}", %{"name" => "jake", "age" => 22})
    assert string == "jake, 22"
  end

  test "parser returns a joined list and function called" do
    string = Parser.execute_string("{{ titleize(join([first_name, last_name], \" \")) }}", %{"first_name" => "jake", "last_name" => "humphrey"})
    assert string == "Jake Humphrey"
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
