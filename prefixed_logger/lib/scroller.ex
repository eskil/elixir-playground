defmodule Scroller do
  require Logger

  def run do
    Logger.metadata([registered_name: "engine"])
    Logger.info("prefixed log")
    Logger.warning(fn -> "lazy prefixed log" end)
  end
end
