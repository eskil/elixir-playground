defmodule Format do
  def format_timestamp({{year, month, day}, {hour, min, sec, micro}}) do
    {:ok, naive} = NaiveDateTime.from_erl({{year, month, day}, {hour, min, sec}}, {micro, 6})
    {:ok, dt} = DateTime.from_naive(naive, "Etc/UTC")
    DateTime.to_string(dt)
  end

  defp color_for(:debug), do: IO.ANSI.cyan()
  defp color_for(:info),  do: IO.ANSI.green()
  defp color_for(:warn),  do: IO.ANSI.yellow()
  defp color_for(:error), do: IO.ANSI.red()
  defp color_for(_),      do: ""

  def format(level, message, timestamp, metadata) do
    t = format_timestamp(timestamp)
    msg =
      case metadata[:prefix] do
        nil -> message
        prefix -> [color_for(level), prefix, IO.ANSI.reset(), " ", message]
      end
    "[#{level}] #{t} #{msg} #{inspect metadata}\n"
  rescue
    _ -> "could not format: #{inspect({level, message, metadata})}"
  end
end
