# PrefixedLogger

## Colour tagging per prefix

### is console?
```elixir
console_enabled? =
  Logger.backends()
  |> Enum.any?(fn
    :console -> true
    %{__struct__: Logger.Backends.Console} -> true
    _ -> false
  end)

```

### perfix consistent colour
```elixir
defp color_for_prefix(prefix) do
  colors = [
    IO.ANSI.red(),
    IO.ANSI.green(),
    IO.ANSI.yellow(),
    IO.ANSI.blue(),
    IO.ANSI.magenta(),
    IO.ANSI.cyan()
  ]

  # Simple hash: take the first char’s codepoint modulo length
  idx = rem(String.to_charlist(prefix) |> hd(), length(colors))
  Enum.at(colors, idx)
end

```


### put together
```elixir
Logger.log(unquote(lvl), fn ->
  msg = unquote(message)

  evaluated =
    case msg do
      fun when is_function(fun, 0) -> fun.()
      other -> other
    end

  if Logger.Backends.Console in Logger.backends() do
    color = PrefixedLogger.color_for_prefix(unquote(prefix))
    [color, unquote(prefix), evaluated, IO.ANSI.reset()]
  else
    [unquote(prefix), evaluated]
  end
end, unquote(metadata))

```

### Full
```elixir
defmodule PrefixedLogger do
  @levels [:debug, :info, :warn, :error]
  @colors [
    IO.ANSI.red(),
    IO.ANSI.green(),
    IO.ANSI.yellow(),
    IO.ANSI.blue(),
    IO.ANSI.magenta(),
    IO.ANSI.cyan()
  ]

  # deterministically pick a color for a given prefix
  defp color_for_prefix(prefix) do
    idx = rem(String.to_charlist(prefix) |> hd(), length(@colors))
    Enum.at(@colors, idx)
  end

  defmacro __using__(opts \\ []) do
    prefix =
      Keyword.get(opts, :prefix) ||
        (__CALLER__.module
         |> Module.split()
         |> List.last()
         |> Macro.underscore()
         |> Kernel.<>(": "))

    Enum.map(@levels, fn level ->
      quote do
        require Logger

        defmacro unquote(level)(message, metadata \\ []) do
          lvl = unquote(level)
          pfx = unquote(prefix)

          quote do
            require Logger

            Logger.log(unquote(lvl), fn ->
              # Evaluate the message
              evaluated =
                case unquote(message) do
                  fun when is_function(fun, 0) -> fun.()
                  other -> other
                end

              # Detect if console backend is active
              console_enabled? =
                Logger.backends()
                |> Enum.any?(fn
                  :console -> true
                  %{__struct__: Logger.Backends.Console} -> true
                  _ -> false
                end)

              if console_enabled? do
                color = PrefixedLogger.send(:color_for_prefix, [unquote(prefix)])
                [color, unquote(prefix), evaluated, IO.ANSI.reset()]
              else
                [unquote(prefix), evaluated]
              end
            end, unquote(metadata))
          end
        end
      end
    end)
  end

  # Helper to allow calling private function from inside macro quote
  def color_for_prefix(prefix), do: color_for_prefix(prefix)
end
```
