# This file contains secrets for test environment

use Mix.Config

# Configure your database connection
config :vue_prefab, VuePrefab.Repo,
  # This URL is for using a docker-compose environment, where the Phoenix container is started
    url: System.get_env("DATABASE_URL", "postgres://phoenix:phoenix@db_test:5433/phoenix_test")

  # This URL is for using a local Phoenix / mix environment, where the App is started via `mix phx.server`
  #url: System.get_env("DATABASE_URL", "postgres://phoenix:phoenix@localhost:5433/phoenix_test")
