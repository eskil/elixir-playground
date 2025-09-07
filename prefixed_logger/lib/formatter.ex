defmodule MyApp.LoggerFormatter do
  @moduledoc false
  alias IO.ANSI

  def format(level, message, timestamp, metadata) do
    prefix = Keyword.get(metadata, :prefix, "")

    message = normalize_message(message)

    ts = format_timestamp(timestamp)

    color =
      case level do
        :debug -> ANSI.faint()
        :info -> ANSI.green()
        :warn -> ANSI.yellow()
        :error -> ANSI.red()
      end

    reset = ANSI.reset()

    [
      ts, " ",
      color, "[", Atom.to_string(level), "] ", reset,
      prefix, message, "\n"
    ]
  end

  defp normalize_message(msg) do
    case msg do
      {:string, iodata} -> IO.iodata_to_binary(iodata)
      fun when is_function(fun, 0) -> normalize_message(fun.())
      iodata -> IO.iodata_to_binary(iodata)
    end
  end

  defp format_timestamp({{year, month, day}, {hour, min, sec, micro}}) do
    microsecond = {micro * 1000, 6} # Logger provides milliseconds; convert to microseconds
    {:ok, naive} = NaiveDateTime.from_erl({{year, month, day}, {hour, min, sec}}, microsecond)
    DateTime.from_naive!(naive, "Etc/UTC") |> DateTime.to_string()
  end
end
