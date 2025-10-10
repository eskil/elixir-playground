import Config

config :logger, :default_formatter,
  format: {MyApp.LoggerFormatter, :format},
  metadata: [:error_code, :file, :line, :registered_name, :prefix, :color]
