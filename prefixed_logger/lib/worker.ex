defmodule Worker do
  use PrefixedLogger, prefix: "worker: "

  def run do
    info("prefixed log")
    warning(fn -> "lazy prefixed log" end)
  end
end
