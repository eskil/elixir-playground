defmodule Engine do
  require Logger

  def run do
    Logger.metadata([registered_name: "engine"])
    Logger.info("starting")
    Logger.debug("plain log")
    Logger.debug("prefixed log")
    Logger.info("prefixed log")
    Logger.info("looking good")
    Logger.info("awesome")
    Logger.warning("prefixed log")
    Logger.error("prefixed log")
    Logger.warning(fn -> "lazy prefixed log" end)

    for i <- 10..1 do
      if rem(i, 3) == 0 do
        Logger.error("#{i} is not the right value")
      else
        Logger.info("countdown #{i}")
      end
      Process.sleep(1000)
    end
  end
end
