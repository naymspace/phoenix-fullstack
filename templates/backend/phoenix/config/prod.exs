import Config

# Do not print debug messages in production
config :logger, level: :info

# Configures the endpoint

config :<%= app_name %>, <%= web_module %>.Endpoint,
       url: [host: {:system, "HOST"}, port: {:system, "PORT"}, scheme: "https"]
