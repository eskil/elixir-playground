import Config

config :logger,
  logger: :console,
  default_level: :info,
  format: {MyApp.LoggerFormatter, :format},
  # Note: you have to specify all metadata names here, eg. :prefix, otherwise
  # it won't be available in the formatter.
  # metadata: [:error_code, :file, :line, :registered_name, :color]
  metadata: [:file]
