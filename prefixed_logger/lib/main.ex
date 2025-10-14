defmodule MyApp do
  require Logger
  def main do
    engine = Task.async(&Engine.run/0)
    Process.sleep(50)
    Logger.info("this log is has no registered name...")
    Logger.metadata([registered_name: "longest-name-part"])
    Logger.info("this log has a registered name...")
    gennie = Task.async(&Generator.run/0)
    worker = Task.async(&Worker.run/0)
  end
end
