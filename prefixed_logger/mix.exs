defmodule PrefixedLogger.MixProject do
  use Mix.Project

  def project do
    [
      app: :prefixed_logger,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      # Since elixir 1.15, use logger_backends, see
      # https://hexdocs.pm/logger/1.18.4/Logger.html#module-backends-and-backwards-compatibility
      # {:logger_backends, "~> 1.0.0"}
    ]
  end
end
