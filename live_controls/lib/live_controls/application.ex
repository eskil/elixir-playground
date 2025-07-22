defmodule LiveControls.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LiveControlsWeb.Telemetry,
      LiveControls.Repo,
      {DNSCluster, query: Application.get_env(:live_controls, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LiveControls.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: LiveControls.Finch},
      # Start a worker by calling: LiveControls.Worker.start_link(arg)
      # {LiveControls.Worker, arg},
      # Start to serve requests, typically the last entry
      LiveControlsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LiveControls.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LiveControlsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
