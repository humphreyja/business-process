defmodule Dashboard.Test.Nodes.Utils.Strings.SerializerTest do
  use ExUnit.Case, async: true
  alias Dashboard.Nodes.Utils.Strings.Serializer

  doctest Serializer

  test "serializer returns integer" do
    integer = Serializer.serialize_value("1", "integer")
    assert integer == 1
  end

  test "serializer returns integer given float" do
    integer = Serializer.serialize_value("1.0", "integer")
    assert integer == 1
  end

  test "serializer integer returns error" do
    integer = Serializer.serialize_value("hello", "integer")
    assert integer == {:error, "Not a valid integer"}
  end

  test "serializer returns decimal" do
    integer = Serializer.serialize_value("1.0", "decimal")
    assert integer == 1.0
  end

  test "serializer returns decimal given integer" do
    integer = Serializer.serialize_value("1", "decimal")
    assert integer == 1.0
  end

  test "serializer decimal returns error" do
    integer = Serializer.serialize_value("hello", "decimal")
    assert integer == {:error, "Not a valid decimal"}
  end

  test "serializer returns phone number as integer" do
    number = Serializer.serialize_value("7153380283", "phone_number")
    assert number == 17153380283

    number = Serializer.serialize_value("17153380283", "phone_number")
    assert number == 17153380283

    number = Serializer.serialize_value("1 (715) 338-0283", "phone_number")
    assert number == 17153380283

    number = Serializer.serialize_value("715-338-0283", "phone_number")
    assert number == 17153380283

    number = Serializer.serialize_value("1 715 338 0283", "phone_number")
    assert number == 17153380283
  end

  test "serializer phone number returns error" do
    number = Serializer.serialize_value("715 blah blah", "phone_number")
    assert number == {:error, "Not a valid phone number"}
  end

  test "serializer returns an email address" do
    email = Serializer.serialize_value("jake@jake.com", "email")
    assert email == "jake@jake.com"

    email = Serializer.serialize_value("sdfls jake@jake.com", "email")
    assert email == "jake@jake.com"
  end

  test "serializer email returns error" do
    email = Serializer.serialize_value("jake@jake", "email")
    assert email == {:error, "Not a valid email"}
  end

  test "serializer returns a number list" do
    assert Serializer.serialize_value("[1,2,3]", "integer") == [1,2,3]
  end

  test "serializer returns a phone number list" do
    assert Serializer.serialize_value("[7153380283,+1 (715) 338-0283,715-338-0283]", "phone_number") == [17153380283,17153380283,17153380283]
  end

end
