import Config

config :logger, :console,
  format: {Formatter, :format}
