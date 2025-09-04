defmodule Engine do
  use PrefixedLogger, prefix: "engine: "

  def run do
    info("prefixed log")
    warning(fn -> "lazy prefixed log" end)
  end
end
