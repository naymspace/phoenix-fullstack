# In this file, we load production configuration and secrets
# from environment variables at runtime instead of compile time.
import Config

# Helper functions
read_to_env_func = fn env_to_file, dest_env, error_message ->
  file =
    System.get_env(env_to_file) ||
      raise """
      environment variable #{env_to_file} is missing.
      #{error_message}
      Save this secret into a file and pass the file path in
      the environment variable #{env_to_file}.
      """

  System.put_env(dest_env, File.read!(file) |> String.trim_trailing())
end

read_func = fn env_to_file, error_message ->
  file =
    System.get_env(env_to_file) ||
      raise "environment variable #{env_to_file} is missing. #{error_message}"

  file
  |> File.read!()
  |> String.trim_trailing()
end

# ENVIRONMENT VARIABLES

# The file mechanism is necessary because Docker Swarm injects
# the secrets as files instead of environment variables

# Secret key for sessions
secret_key_base =
  read_func.("SECRET_KEY_BASE_FILE", "You can generate a secret by calling: mix phx.gen.secret .")

# Database URL
read_to_env_func.(
                 "DATABASE_URL_FILE",
                 "DATABASE_URL",
                 "Must have the format: postgres://USER:PASS@HOST/DATABASE ."
                 )

config :<%= app_name %>, <%= app_module %>.Repo,
       # ssl: true,
       pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

config :<%= app_name %>, <%= web_module %>.Endpoint, secret_key_base: secret_key_base

# Necessary to start the server
config :<%= app_name %>, <%= web_module %>.Endpoint, server: true
