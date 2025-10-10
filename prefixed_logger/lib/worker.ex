defmodule Worker do
  require Logger

  def run do
    Logger.metadata([registered_name: "worker"])
    Logger.info("hmm prefixed log")
    Logger.warn(fn -> "lazy prefixed log" end)
  end
end
