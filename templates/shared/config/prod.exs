use Mix.Config

# Do not print debug messages in production
config :logger, level: :info

config :<%= app_name %>, <%= web_module %>.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true
