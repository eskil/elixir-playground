defmodule Scroller do
  use PrefixedLogger, prefix: "scroller: "

  def run do
    info("prefixed log")
    warning(fn -> "lazy prefixed log" end)
  end
end
