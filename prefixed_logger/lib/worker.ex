defmodule Worker do
  require Logger

  def run do
    Logger.metadata([registered_name: "worker"])
    Logger.info("worker #{inspect self()} starting")
    Logger.info("hmm prefixed log")
    Logger.warn(fn -> "lazy prefixed log" end)
    Logger.warning("warning...")
    Logger.error(fn -> "lazy prefixed error" end)
    Logger.critical(fn -> "lazy prefixed critical" end)

    for i <- 50..1 do
      if rem(i, 5) == 0 do
        Logger.debug("countdown has reached another fifth of the way")
      end
      if rem(i, 4) == 0 do
        Logger.debug("sometimes check #{i} % 4 for variety")
      end
      Logger.info("countdown #{i} #{String.duplicate("adf", rem(i, 5))}")
      Process.sleep(200)
    end
  end
end
