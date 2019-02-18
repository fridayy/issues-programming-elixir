use Mix.Config

config :issues, :http_client, HTTP.PoisonHTTP
config :logger, compile_time_purge_level: :info
