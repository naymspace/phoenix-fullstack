use Mix.Config

# Configure your database
config :<%= app_name %>, <%= app_module %>.Repo,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :<%= app_name %>, <%= web_module %>.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

if File.exists?("test.secret.exs") do
  import_config "test.secret.exs"
end
