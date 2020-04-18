use Mix.Config

# Do not print debug messages in production
config :logger, level: :info

config :vue_prefab, VuePrefabWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true
