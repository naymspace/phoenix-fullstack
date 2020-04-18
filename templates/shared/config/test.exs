use Mix.Config

# Configure your database
config :vue_prefab, VuePrefab.Repo,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :vue_prefab, VuePrefabWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

if File.exists?("test.secret.exs") do
  import_config "test.secret.exs"
end
