defmodule CompileDependenciesTest do
  use ExUnit.Case
  doctest CompileDependencies

  test "greets the world" do
    assert CompileDependencies.hello() == :world
  end
end
