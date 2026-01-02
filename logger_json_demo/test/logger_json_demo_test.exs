defmodule LoggerJsonDemoTest do
  use ExUnit.Case
  doctest LoggerJsonDemo

  test "greets the world" do
    assert LoggerJsonDemo.hello() == :world
  end
end
