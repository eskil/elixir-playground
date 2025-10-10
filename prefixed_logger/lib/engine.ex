defmodule Engine do
  require Logger

  def run do
    Logger.metadata([registered_name: "engine"])
    Logger.debug("plain log")
    Logger.debug("prefixed log")
    Logger.info("prefixed log")
    Logger.warning("prefixed log")
    Logger.error("prefixed log")
    Logger.warning(fn -> "lazy prefixed log" end)
  end
end
