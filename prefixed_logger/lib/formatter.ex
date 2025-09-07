defmodule Formatter do
  @pattern Logger.Formatter.compile("$time $metadata[$level] $message\n")

  def format(level, message, timestamp, metadata) do
    # If :prefix metadata exists, incorporate it (with colour for console)
    msg =
      case Keyword.get(metadata, :prefix) do
        nil ->
          message

        prefix ->
          [color_for(level), prefix, IO.ANSI.reset(), " ", message]
      end

    Logger.Formatter.format(@pattern, level, msg, timestamp, metadata)
  end

  defp color_for(:debug), do: IO.ANSI.cyan()
  defp color_for(:info),  do: IO.ANSI.green()
  defp color_for(:warn),  do: IO.ANSI.yellow()
  defp color_for(:error), do: IO.ANSI.red()
  defp color_for(_),      do: ""
end
