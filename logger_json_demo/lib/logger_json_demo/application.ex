defmodule LoggerJsonDemo.Application do
  use Application

  @worker_count 3
  @interval 2000 # ms

  def start(_type, _args) do
    formatter = LoggerJSON.Formatters.Basic.new(metadata: :all)
    :logger.update_handler_config(:default, :formatter, formatter)

    worker_children = for i <- 1..@worker_count do
      %{
        id: {LoggerJsonDemo.Worker, i},
        start: {LoggerJsonDemo.Worker, :start_link, [[id: i, interval: @interval]]}
      }
    end
    children = [
      {Registry, keys: :unique, name: LoggerJsonDemo.Registry}
      | worker_children
    ]
    opts = [strategy: :one_for_one, name: LoggerJsonDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end
end