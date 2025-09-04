defmodule Main do
  use PrefixedLogger, prefix: "main: "

  def run do
    info("main")
    Engine.run()
    Scroller.run()
    Worker.run()
  end
end
