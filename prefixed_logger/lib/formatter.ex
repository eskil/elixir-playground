defmodule Format do
  def format_timestamp({{year, month, day}, {hour, min, sec, micro}}) do
    {:ok, naive} = NaiveDateTime.from_erl({{year, month, day}, {hour, min, sec}}, {micro, 6})
    {:ok, dt} = DateTime.from_naive(naive, "Etc/UTC")
    DateTime.to_string(dt)
  end

  def format(level, message, timestamp, metadata) do
    t = format_timestamp(timestamp)
    "[#{level}] #{t} #{message} #{inspect metadata}\n"
  rescue
    _ -> "could not format: #{inspect({level, message, metadata})}"
  end
end
