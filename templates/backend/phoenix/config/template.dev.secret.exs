put_env_if_absent = fn key, value ->
  if System.get_env(key) |> is_nil, do: System.put_env(key, value)
  nil
end

# Add other environment variables for local testing
put_env_if_absent.("HOST", "localhost")
put_env_if_absent.("PORT", "4000")
put_env_if_absent.("DATABASE_URL", "postgres://app:app@localhost:<%= db_dev_port %>/app_development")
