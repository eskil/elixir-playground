defmodule LoggerJsonDemo.JsonFormatter do
  @moduledoc """
  Logger formatter that outputs logs as JSON, encoding all metadata and handling PIDs, tuples, and lists.
  """
  @behaviour Logger.Formatter

  def format(level, message, timestamp, metadata) do
    log_map = %{
      time: format_time(timestamp),
      severity: level,
      message: IO.iodata_to_binary(message),
      metadata: encode_metadata(metadata)
    }
    Jason.encode!(log_map) <> "\n"
  end

  defp format_time({date, {h, m, s, ms}}) do
    {{y, mo, d}, _} = {date, {h, m, s, ms}}
    {:ok, dt} = NaiveDateTime.new(y, mo, d, h, m, s, ms * 1000)
    DateTime.from_naive!(dt, "Etc/UTC") |> DateTime.to_iso8601()
  end

  defp encode_metadata(meta) when is_list(meta) do
    Enum.into(meta, %{}, fn {k, v} -> {k, encode_value(v)} end)
  end

  defp encode_value(v) when is_pid(v), do: inspect(v)
  defp encode_value(v) when is_tuple(v), do: Tuple.to_list(v)
  defp encode_value(v) when is_list(v), do: Enum.map(v, &encode_value/1)
  defp encode_value(v), do: v
end
