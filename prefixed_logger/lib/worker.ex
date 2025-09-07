defmodule Worker do
  use PrefixedLogger, prefix: "worker: "

  def run do
    info("prefixed log")
    warn(fn -> "lazy prefixed log" end)
  end
end
