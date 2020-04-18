# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :vue_prefab,
  ecto_repos: [VuePrefab.Repo]

# Configures the endpoint
config :vue_prefab, VuePrefabWeb.Endpoint,
  url: [host: System.get_env("HOST", "localhost")],
  # Generated secret key - production uses one from env variables
  secret_key_base: "6nB+yWk3GEsNFwGov1EcdClLJtZgym4kzSYZf/V2MpYvUMreCgsVUlPSmiH8uvvy",
  render_errors: [view: VuePrefabWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: VuePrefab.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "S4gn7lpo"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
