defmodule Engine do
  use PrefixedLogger, prefix: "engine: "
  require Logger

  def run do
    Logger.debug("plain log")
    debug("prefixed log")
    info("prefixed log")
    warning("prefixed log")
    error("prefixed log")
    warning(fn -> "lazy prefixed log" end)
  end
end
