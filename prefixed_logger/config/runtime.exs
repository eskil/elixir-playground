import Config

config :logger, :console,
  format: {MyApp.LoggerFormatter, :format}
