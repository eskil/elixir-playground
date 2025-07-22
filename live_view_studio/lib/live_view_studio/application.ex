defmodule LiveViewStudio.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LiveViewStudioWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:live_view_studio, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LiveViewStudio.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: LiveViewStudio.Finch},
      # Start a worker by calling: LiveViewStudio.Worker.start_link(arg)
      # {LiveViewStudio.Worker, arg},
      # Start to serve requests, typically the last entry
      LiveViewStudioWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LiveViewStudio.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LiveViewStudioWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
