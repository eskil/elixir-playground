defmodule MyApp.LoggerFormatter do
  @moduledoc """
  The custom logger logs messages with a colorised prefix, and colors the
  message by level.

  The prefix is set by setting a `:registered_name` in metadata and optionally
  a `:color` in the process. If `:registered_name` isn't set, it defaults to
  `Process.info(self(), :registered_name)`.

  ```elixir
  def init(state) do
    Logger.metadata(registered_name: "worker", color: :green)
  end
  ```

  If the `:color` it not set, and consistent color is picked by hashing the prefix.

  Enable the logging formatter in your config. Note, you have to specify
  `:color` in `metadata` for them to be passed to the logger.

  `config/runtime.exs`
  ```elixir
  config :logger,
    logger: :console,
    default_level: :info,
    format: {MyApp.LoggerFormatter, :format},
    metadata: [:error_code, :file, :line, :registered_name, :color],
  ```

  Or to combine with flexlogger;

  ```elixir
  config :logger,
    backends: [{FlexLogger, :myapp_logger}]

  config :logger, :myapp_logger,
    logger: :console,
    default_level: :info,
    format: {MyApp.LoggerFormatter, :format},
    metadata: [:error_code, :file, :line, :registered_name, :color],
  ```
  """
  alias IO.ANSI

  ###
  # Format an erlang timestamp to a prettier string
  #
  @spec format_timestamp({{year :: integer, month :: integer, day :: integer},
                          {hour :: integer, min :: integer, sec :: integer, micro :: integer}},
    precision :: :s | :ms | :us) :: iodata()
  def format_timestamp({{year, month, day}, {hour, min, sec, _ms}}, :us) do
    micros = System.system_time(:microsecond)
    usec = rem(micros, 1_000_000)

    :io_lib.format(
      "~4..0B-~2..0B-~2..0B ~2..0B:~2..0B:~2..0B.~6..0B",
      [year, month, day, hour, min, sec, usec]
    )
  end

  def format_timestamp({{year, month, day}, {hour, min, sec, ms}}, :ms) do
    :io_lib.format(
      "~4..0B-~2..0B-~2..0B ~2..0B:~2..0B:~2..0B.~3..0B",
      [year, month, day, hour, min, sec, ms]
    )
  end

  def format_timestamp({{year, month, day}, {hour, min, sec, _micro}}, :s) do
    # Whole seconds only
    :io_lib.format(
      "~4..0B-~2..0B-~2..0B ~2..0B:~2..0B:~2..0B",
      [year, month, day, hour, min, sec]
    )
  end

  def format_timestamp(ts), do: format_timestamp(ts, :ms)

  ###
  # Pick a consistent (using hash) color for a given prefix
  #

  @colors [
    :red,
    :green,
    :yellow,
    :blue,
    :magenta,
    :cyan,
    :white,
    :light_red,
    :light_green,
    :light_yellow,
    :light_blue,
    :light_magenta,
    :light_cyan,
    :light_white,
  ]

  def color_for(nil, "") do
      "reset"
  end

  def color_for(nil, file) do
    idx = :erlang.phash2(file, length(@colors))
    Enum.at(@colors, idx)
  end

  def color_for(name, _) when is_binary(name) do
    idx = :erlang.phash2(name, length(@colors))
    Enum.at(@colors, idx)
  end

  def color_for(_name, _) do
    "reset"
  end

  ##
  # Manage in an ets table. State is eg. longest current prefix.
  # TODO: also track resetting it, eg after :io.rows lines logged
  # or a time
  #
  @ets_table :pretty_logger_formatter
  @ets_maxlen_key :longest

  defp ensure_table do
    case :ets.info(@ets_table) do
      :undefined ->
        :ets.new(@ets_table, [:named_table, :public])
        :ets.insert(@ets_table, {@ets_maxlen_key, 0})
      _ -> :ok
    end
  end

  def get_and_set_max_len(prefix) do
    ensure_table()
    [{@ets_maxlen_key, max}] = :ets.lookup(@ets_table, @ets_maxlen_key)
    new_max = max(String.length(prefix), max)
    if new_max != max, do: :ets.insert(@ets_table, {@ets_maxlen_key, new_max})
    new_max
  end

  ##
  # Helper functions to extra metadata
  def get_prefix_default do
    {:registered_name, prefix} = Process.info(self(), :registered_name)
    case prefix do
      [] -> ""
      _ -> prefix
    end
  end

  ##
  # The formatted mess^H^H^Hfunction
  #

  def format(level, message, ts, metadata) do
    {prefix, metadata} = Keyword.pop(metadata, :registered_name, get_prefix_default())

    {file, metadata} = Keyword.pop(metadata, :file, "")
    {line, metadata} = Keyword.pop(metadata, :line, "")
    {color_name, _metadata} = Keyword.pop(metadata, :color, color_for(prefix, file))
    t = format_timestamp(ts)
    color = apply(ANSI, color_name, [])
    reset = ANSI.reset()

    level_color =
      case level do
        :emergency -> ANSI.red()
        :alert -> ANSI.red()
        :critical -> ANSI.red()
        :error -> ANSI.light_red()
        :warning -> ANSI.yellow()
        :notice -> ANSI.reset()
        :info -> ANSI.reset()
        :debug -> ANSI.cyan()
      end

    msg_color =
      case level do
        :emergency -> ANSI.red()
        :alert -> ANSI.red()
        :critical -> ANSI.red()
        :error -> ANSI.light_red()
        :warning -> ANSI.yellow()
        :notice -> ANSI.reset()
        :info -> ANSI.reset()
        :debug -> ANSI.reset()
      end

    level_str =
      case level do
        :emergency -> "EMERG"
        :alert -> "ALERT"
        :critical -> "CRIT"
        :error -> "ERROR"
        :warning -> "WARN"
        :notice -> "NOTE"
        :info -> "INFO"
        :debug -> "dbg"
      end
    |> String.pad_leading(5)

    faint_color = ANSI.faint()

    # Set padding to longest seen prefix - no ideal, should probably shrink again over
    # time or have a max?
    new_max = get_and_set_max_len(prefix)

    header_io = ["\n", t, " "]
    level_io = [level_color, level_str, reset, " "]
    prefix_io = case prefix do
                   nil -> []
                   _ -> [color, String.pad_trailing(prefix, new_max), reset, " "]
                 end
    message_io = [msg_color, message, " "]
    file_io = [faint_color, file, ":", Integer.to_string(line), reset]

    [
      header_io,
      prefix_io,
      level_io,
      message_io,
      file_io,
    ]
  rescue
    e -> "could not format: #{inspect({level, message, metadata})}: error: #{inspect e}"
  end
end
