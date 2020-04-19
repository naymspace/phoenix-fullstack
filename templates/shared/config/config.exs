# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :<%= app_name %>,
  ecto_repos: [<%= app_module %>.Repo]

# Configures the endpoint
config :<%= app_name %>, <%= web_module %>.Endpoint,
  url: [host: System.get_env("HOST", "localhost")],
  # Generated secret key - production uses one from env variables
  secret_key_base: "<%= :crypto.strong_rand_bytes(64) |> Base.encode64 |> binary_part(0, 64) %>",
  render_errors: [view: <%= web_module %>.ErrorView, accepts: ~w(html json)],
  pubsub: [name: <%= app_module %>.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "<%= :crypto.strong_rand_bytes(8) |> Base.encode64 |> binary_part(0, 8) %>"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
