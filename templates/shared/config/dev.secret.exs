# This file contains secrets for development environment

use Mix.Config

# Configure your database connection
config :<%= app_name %>, <%= app_module %>.Repo,
  # This URL is for using a docker-compose environment, where the Phoenix container is started
    url: System.get_env("DATABASE_URL", "postgres://phoenix:phoenix@db_dev:5432/phoenix_dev")

  # This URL is for using a local Phoenix / mix environment, where the App is started via `mix phx.server`
  #url: System.get_env("DATABASE_URL", "postgres://phoenix:phoenix@localhost:5432/phoenix_dev")
