defmodule PrefixedLogger do
  @levels [:debug, :info, :warning, :error]

  def eval_msg(msg) when is_function(msg, 0), do: msg.()
  def eval_msg(msg), do: msg

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
            Logger.log(
              unquote(lvl),
              fn ->
                evaluated = PrefixedLogger.eval_msg(unquote(message))
                [unquote(pfx), evaluated]
              end,
              Keyword.put_new(unquote(metadata), :prefix, unquote(pfx))
            )
          end
        end
      end
    end)
  end
end
