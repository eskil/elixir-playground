defmodule Http2server.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Http2serverWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:http2server, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Http2server.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Http2server.Finch},
      # Start a worker by calling: Http2server.Worker.start_link(arg)
      # {Http2server.Worker, arg},
      # Start to serve requests, typically the last entry
      Http2serverWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Http2server.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Http2serverWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
