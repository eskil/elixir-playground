defmodule PrefixedLogger do
  @moduledoc false

  defmacro __using__(opts \\ []) do
    caller = __CALLER__.module

    default_prefix =
      caller
      |> Module.split()
      |> List.last()
      |> Macro.underscore()
      |> Kernel.<>(": ")

    prefix = Keyword.get(opts, :prefix, default_prefix)

    quote bind_quoted: [prefix: prefix] do
      require Logger
      @logger_prefix prefix

      defp evaluate_message(msg) when is_function(msg, 0), do: msg.()
      defp evaluate_message(msg), do: msg

      defmacro debug(message, metadata \\ []) do
        quote do
          md = Keyword.put_new(unquote(metadata), :prefix, @logger_prefix)

          Logger.log(:debug, fn ->
            [@logger_prefix, evaluate_message(unquote(message))]
          end, md)
        end
      end

      defmacro info(message, metadata \\ []) do
        quote do
          md = Keyword.put_new(unquote(metadata), :prefix, @logger_prefix)

          Logger.log(:info, fn ->
            [@logger_prefix, evaluate_message(unquote(message))]
          end, md)
        end
      end

      defmacro warning(message, metadata \\ []) do
        quote do
          md = Keyword.put_new(unquote(metadata), :prefix, @logger_prefix)

          Logger.log(:warning, fn ->
            [@logger_prefix, evaluate_message(unquote(message))]
          end, md)
        end
      end

      defmacro error(message, metadata \\ []) do
        quote do
          md = Keyword.put_new(unquote(metadata), :prefix, @logger_prefix)

          Logger.log(:error, fn ->
            [@logger_prefix, evaluate_message(unquote(message))]
          end, md)
        end
      end

      # alias: warn/2 -> warning/2
      defmacro warn(message, metadata \\ []) do
        quote do
          warning(unquote(message), unquote(metadata))
        end
      end
    end
  end
end
