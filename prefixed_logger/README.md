# PrefixedLogger

TODO: configurably things
- color off when :io.getopts[:terminal] is false?
- disable date
- disable file/line
- s/ms/us resolution
- as format? "%data %time.%us %prefix %level %source"
- runtime configurable level per prefix/module? Similar to flexlogger, but ets backed
  so runtime configurable?


## Colour tagging per prefix

### is console?
```elixir
iex(1)> :io.getopts
[
  expand_fun: #Function<4.67009637/2 in :group.normalize_expand_fun/2>,
  echo: true,
  line_history: true,
  log: :none,
  binary: true,
  encoding: :unicode,
  terminal: true,
  stdout: true,
  stderr: true,
  stdin: true
]
```

Screen dimensions

```elixir
iex(2)> :io.rows
{:ok, 35}
iex(3)> :io.columns
{:ok, 135}
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
