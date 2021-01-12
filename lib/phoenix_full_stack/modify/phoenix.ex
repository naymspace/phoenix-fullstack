defmodule PhoenixFullStack.Modify.Phoenix do
  @moduledoc false
  import PhoenixFullStack.Templates

  @source_prefix "backend/phoenix"
  @target_prefix "phoenix_api"

  def modify(path, template_bindings) do
    path = Path.join(path, @target_prefix)
    rewrite_mix_file(path)
    rewrite_configs(path, template_bindings)
    add_files(path, template_bindings)
  end

  defp rewrite_mix_file(path) do
    file = Path.expand("mix.exs", path)
    Mix.shell().info("Rewriting mix.exs at '#{Path.relative_to_cwd(file)}' ...")
    lines = File.read!(file)

    # Replace default
    lines =
      String.replace(
        lines,
        ~r/defp aliases do\s+\[.*\]\s+end/s,
        """
        defp aliases do
            [
              "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
              "ecto.reset": ["ecto.pg_drop", "ecto.create", "ecto.migrate"],
              "ecto.reset-quiet": ["ecto.pg_drop", "ecto.create", "ecto.migrate"],
              "ecto.reseed": ["ecto.pg_drop", "ecto.setup"],
              "ecto.reseed-quiet": ["ecto.pg_drop -y", "ecto.setup"],
              "ecto.seed": ["run priv/repo/seeds.exs"],
              test: ["ecto.create --quiet", "ecto.pg_drop", "ecto.migrate", "test"],
              "test-quiet": ["ecto.create --quiet", "ecto.pg_drop -y", "ecto.migrate", "test"]
            ]
          end
        """
      )

    File.write!(file, lines)
  end

  defp rewrite_configs(path, template_bindings) do
    config_path = Path.join(path, "/config")
    rewrite_main_config(config_path, template_bindings)
    rewrite_configs_import(config_path)
  end

  # Replace the import and load secret file before
  def rewrite_main_config(config_path, template_bindings) do
    main_config = Path.join(config_path, "config.exs")

    lines =
      File.read!(main_config)
      |> String.replace(
        ~r/use Mix.Config/s,
        """
        import Config

        if File.exists?("config/#{Mix.env()}.secret.exs") do
          import_config "#{Mix.env()}.secret.exs"
        end
        """
      )
      |> String.replace(
        ~r/# Configures the endpoint\nconfig :(.*)# Configures Elixir's Logger/s,
        """
        # Configures the endpoint
        config :#{template_bindings[:app_name]}, #{template_bindings[:web_module]}.Endpoint,
           url: [
             host: {:system, "HOST"},
             port: {:system, "PORT"},
             scheme: System.get_env("SCHEME") || "http"
           ],
           http: [port: 4000, compress: true],
           render_errors: [view: #{template_bindings[:web_module]}.ErrorView, accepts: ~w(html json)],
           pubsub_server: #{template_bindings[:app_module]}.PubSub,
           live_view: [signing_salt: "IsQj0r6P"]

        # Configures Elixir's Logger
        """
      )

    File.write!(main_config, lines)
  end

  # Phoenix generates a config file using Mix.Config, which is deprecated and should be replaced by Config
  defp rewrite_configs_import(config_path) do
    File.ls!(config_path)
    |> Enum.each(fn config_file ->
      config_file = Path.join(config_path, config_file)

      lines =
        File.read!(config_file)
        |> String.replace(
          ~r/use Mix.Config/s,
          "import Config"
        )

      File.write!(config_file, lines)
    end)

    # We do not need the production secret file because all are loaded via the release file
    File.rm!(Path.join(config_path, "prod.secret.exs"))
  end

  defp add_files(path, template_bindings) do
    app_path = path <> "/lib/" <> template_bindings[:app_name]
    copy_file(@source_prefix <> "/mix_tasks/pg_drop.ex", path <> "/lib/mix/tasks/ecto/pg_drop.ex")

    eval_file(
      @source_prefix <> "/config/releases.exs",
      path <> "/config/releases.exs",
      template_bindings
    )

    eval_file(@source_prefix <> "/lib/app/repo.ex", app_path <> "/repo.ex", template_bindings)

    eval_file(
      @source_prefix <> "/lib/app/release.ex",
      app_path <> "/release.ex",
      template_bindings
    )

    eval_file(@source_prefix <> "/config/prod.exs", path <> "/config/prod.exs", template_bindings)

    copy_file(
      @source_prefix <> "/config/template.dev.secret.exs",
      path <> "/config/template.dev.secret.exs"
    )

    copy_file(
      @source_prefix <> "/config/template.test.secret.exs",
      path <> "/config/template.test.secret.exs"
    )

    # Dockerfiles
    copy_file(
      @source_prefix <> "/docker/Dockerfile_analyze",
      path <> "/docker/Dockerfile_analyze"
    )

    copy_file(
      @source_prefix <> "/docker/Dockerfile_dev",
      path <> "/docker/Dockerfile_dev"
    )

    eval_file(
      @source_prefix <> "/docker/Dockerfile_prod.exs",
      path <> "/docker/Dockerfile_prod",
      template_bindings
    )
  end
end
