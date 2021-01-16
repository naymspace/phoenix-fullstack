defmodule PhoenixFullStack.Modify.Phoenix do
  @moduledoc false
  import PhoenixFullStack.Templates

  @source_prefix "backend/phoenix"
  @target_prefix "phoenix_api"

  def modify(path, template_bindings) do
    path = Path.join(path, @target_prefix)
    rewrite_mix_file(path, template_bindings)
    rewrite_endpoint(path, template_bindings)
    rewrite_router(path, template_bindings)
    rewrite_configs(path, template_bindings)
    rewrite_test_setup(path, template_bindings)
    add_files(path, template_bindings)
    clean_up(path)
  end

  defp rewrite_mix_file(path, template_bindings) do
    file = Path.expand("mix.exs", path)

    deps =
      load_deps(path, template_bindings)
      |> Enum.map_join(",\n    ", fn e -> "{:#{elem(e, 0)}, \"#{elem(e, 1)}\"}" end)

    Mix.shell().info("Rewriting mix.exs at '#{Path.relative_to_cwd(file)}' ...")

    lines =
      file
      |> File.read!()
      # Increase version
      |> String.replace(
        ~r/elixir: "~> 1.7",/,
        "elixir: \"~> 1.11\","
      )
      # Replace default aliases with "better" ones
      |> String.replace(
        ~r/defp aliases do\s+\[.*?\]\s+end/s,
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
      # Expand the dependencies with useful libraries
      |> String.replace(
        ~r/defp deps do\s+(\[.*?\])\s+end/s,
        """
        defp deps do
          [
            #{deps}
          ]
          end
        """
      )
      # Add factory to test loading
      |> String.replace(
        "defp elixirc_paths(:test), do: [\"lib\", \"test/support\"]",
        "defp elixirc_paths(:test), do: [\"lib\", \"test/support\", \"test/factory\"]"
      )

    File.write!(file, lines)
  end

  defp load_deps(path, template_bindings) do
    Mix.Project.in_project(String.to_atom(template_bindings[:app_name]), path, fn _ ->
      Mix.Project.config()
    end)
    |> Keyword.fetch!(:deps)
    |> Enum.concat([
      # Convert cases automatically
      {:accent, "~> 1.0"},
      # Adding pagination to ecto
      {:scrivener_ecto, "~> 2.7"},
      # Static-Code analysis
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      # Audit for mix dependencies
      {:mix_audit, "~> 0.1", only: [:dev, :test], runtime: false},
      # Generate random test data
      {:faker, "~> 0.16", only: :test},
      # Factory-bot like tool to easily create complex data structures for tests
      {:ex_machina, "~> 2.5", only: :test}
    ])
    |> List.keysort(0)
  end

  defp rewrite_endpoint(path, template_bindings) do
    file = Path.join(path, "/lib/#{template_bindings[:app_name]}_web/endpoint.ex")
    #  plug Accent.Plug.Request
    #
    #  plug Plug.MethodOverride
    lines =
      file
      |> File.read!()
      # Add accent to pipe
      |> String.replace(
        "plug Plug.MethodOverride",
        """
         plug Accent.Plug.Request

         plug Plug.MethodOverride
        """
      )

    File.write!(file, lines)
  end

  defp rewrite_router(path, template_bindings) do
    file = Path.join(path, "/lib/#{template_bindings[:app_name]}_web/router.ex")

    lines =
      file
      |> File.read!()
      # Add accent to pipe
      |> String.replace(
        """
          pipeline :api do
            plug :accepts, ["json"]
          end
        """,
        """
          pipeline :api do
            plug :accepts, ["json"]

            plug Accent.Plug.Request

            plug Accent.Plug.Response,
            default_case: Accent.Case.Camel,
            json_codec: Jason
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

  defp rewrite_test_setup(path, template_bindings) do
    [{"conn_case.ex", "ConnTest"}, {"channel_case.ex", "ChannelTest"}]
    |> Enum.each(fn {file, anchor} ->
      # Conn case
      lines =
        File.read!(path <> "/test/support/" <> file)
        |> String.replace(
          "import Phoenix.#{anchor}",
          """
          import Phoenix.#{anchor}
          import #{template_bindings[:app_module]}.Factory
          """
        )

      File.write!(path <> "/test/support/" <> file, lines)
    end)
  end

  defp add_files(path, template_bindings) do
    eval_file(
      @source_prefix <> "/mix_tasks/pg_drop.ex",
      path <> "/lib/mix/tasks/ecto/pg_drop.ex",
      template_bindings
    )

    eval_directory(@source_prefix <> "/config/", path <> "/config/", template_bindings)

    eval_directory(
      @source_prefix <> "/lib/app/",
      path <> "/lib/" <> template_bindings[:app_name],
      template_bindings
    )

    eval_directory(@source_prefix <> "/docker/", path <> "/docker/", template_bindings)

    # Test files
    eval_directory(@source_prefix <> "/test/", path <> "/test/", template_bindings)
  end

  defp clean_up(path) do
    File.cd!(path, fn ->
      Mix.shell().cmd("mix deps.get")
      Mix.shell().cmd("mix format")
    end)
  end
end
