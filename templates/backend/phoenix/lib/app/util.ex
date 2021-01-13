defmodule <%= app_module %>.Util do
  @doc """
  Fetches an environment variable set at runtime. If the value has the form {:system, "ENV_KEY"}, the function
  will read the value from the System environment.

  Otherwise the value is returned.

  This enables us to avoid the problem with compile time environment variables. This process can be simplified in the
  future with Elixir 1.11 and its config/runtime.exs.

  ## Examples

  Using a system tuple:

      config :<%= app_name %>,
             frontend_host: {:system, "HOST"}

      runtime_env(:<%= app_name %>, :host)
      localhost

  Using the direct value:

      config :<%= app_name %>,
             host: "other_value"

      runtime_env(:<%= app_name %>, :host)
      other_value
  """
  def runtime_env(app, key) do
    case Application.fetch_env!(app, key) do
      {:system, env} when is_binary(env) -> System.fetch_env!(env)
      value -> value
    end
  end

  @doc """
  Same functionality as runtime_env/2, but for Keywords in the config.

  ## Examples

  Using a system tuple (the value is set in the System Environment):

      config :<%= app_name %>, :paypal
             key: {:system, "PAYPAL_KEY"}

      runtime_env(:<%= app_name %>, :paypal, :key)
      # returns "secret_key_to_your_wallet"

  Using the direct value:

      config :<%= app_name %>,
              key: "never do this"

      runtime_env(:<%= app_name %>, :frontend_host)
      # returns "never to this"
  """
  def runtime_env(app, module, key) do
    app
    |> Application.fetch_env!(module)
    |> Keyword.fetch!(key)
    |> case do
         {:system, env} when is_binary(env) -> System.fetch_env!(env)
         value -> value
       end
  end
end
