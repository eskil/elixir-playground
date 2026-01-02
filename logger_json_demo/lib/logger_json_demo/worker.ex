defmodule LoggerJsonDemo.Worker do
  use GenServer

  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: via_tuple(opts[:id]))
  end

  defp via_tuple(id), do: {:via, Registry, {LoggerJsonDemo.Registry, id}}

  def init(opts) do
    schedule_tick(opts[:interval])
    {:ok, opts}
  end

  def handle_info(:tick, state) do
    # Example: log a random key-value pair per message
    extra =
      case :rand.uniform(3) do
        1 -> [foo: "bar"]
        2 -> [baz: 123]
        3 -> [custom: :value, random: :rand.uniform(100)]
      end
    details = [
      worker_id: state[:id],
      interval: state[:interval],
      pid: self(),
      timestamp: DateTime.utc_now()
    ] ++ extra
    Logger.metadata(details: details)
    Logger.info("Worker #{state[:id]} logging every #{state[:interval]} ms")
    schedule_tick(state[:interval])
    {:noreply, state}
  end

  defp schedule_tick(interval) do
    Process.send_after(self(), :tick, interval)
  end
end