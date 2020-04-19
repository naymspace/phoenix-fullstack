defmodule PhoenixTemplate.React do
  @moduledoc """
  React specific operation
  """

  def run(path) do
    path
    |> copy_template_files()
    |> rewrite()
  end

  defp copy_template_files(path) do
    # Remove generated asset files
    asset_path = Path.expand("assets/", path)
    Mix.shell().info("Remove existing asset directory  '#{Path.relative_to_cwd(asset_path)}' ...")
    File.rm_rf!(asset_path)
    # Copy asset directory containing all vue frontend information
    Mix.shell().info("Copying asset directory to '#{Path.relative_to_cwd(asset_path)}' ...")
    File.cp_r("templates/react/assets/", asset_path)

    # Replace web templates to support the vue js application (Add `app` div, change js and css in index.html)
    Mix.shell().info("Replacing web templates ...")
    project_path = Path.expand("lib/", path)
    web_path = Path.expand("#{Macro.underscore(path)}_web/", project_path)

    File.cp(
      "templates/react/web/templates/layout/app.html.eex",
      Path.expand("templates/layout/app.html.eex", web_path)
    )

    File.cp(
      "templates/react/web/templates/page/index.html.eex",
      Path.expand("templates/page/index.html.eex", web_path)
    )

    path
  end

  defp rewrite(path) do
    config_path = Path.expand("config/", path)
    rewrite_dev_watcher(config_path)
    path
  end

  defp rewrite_dev_watcher(config_path) do
    file = Path.expand("dev.exs", config_path)
    Mix.shell().info("Rewriting dev watcher at '#{Path.relative_to_cwd(file)}' ...")
    lines = File.read!(file)

    # Replace `only` part to serve img instead of images
    lines =
      String.replace(
        lines,
        ~r/watchers: \[.*\],/s,
        """
        watchers: [
            node: [
              "node_modules/webpack/bin/webpack.js",
              "--mode",
              "development",
              "--watch-stdin",
              cd: Path.expand("../assets", __DIR__)
          ]
        ]
        """
      )

    File.write!(file, lines)
  end
end
