defmodule Generator do
  require Logger

  def run do
    Logger.metadata([registered_name: "generator"])
    Logger.info("prefixed log")
    Logger.info("prefixed log asdfsad")
    Logger.info("prefixed log foobar")
    Logger.info("prefixed log snafu")
    Logger.warning(fn -> "lazy prefixed log" end)
    Logger.error(fn -> "lazy prefixed emergency" end)
    Logger.critical("prefixed critical")
    Logger.emergency("prefixed emergency")

    for i <- 30..1 do
      Logger.info("#{String.duplicate("word", rem(i, 5))} countdown #{i} ")
      if rem(i, 10) == 0 do
        Logger.warn("doing things in generator for value #{i}")
      end
      if (rem(i, 2) == 0) do
           Process.sleep(333)
      end
    end
  end
end
