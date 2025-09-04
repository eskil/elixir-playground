defmodule PrefixedLoggerTest do
  use ExUnit.Case
  doctest PrefixedLogger

  test "greets the world" do
    assert PrefixedLogger.hello() == :world
  end
end
