defmodule Worker do
  use PrefixedLogger, prefix: "worker: "

  def run do
    info("hmm prefixed log")
    warn(fn -> "lazy prefixed log" end)
  end
end
