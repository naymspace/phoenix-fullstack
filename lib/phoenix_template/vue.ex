defmodule PhoenixTemplate.Vue do
  @moduledoc """
  Vue specific operation
  """

  def run(path) do
    path
    |> rewrite()
    |> copy_template_files()
  end

  def rewrite(path) do
    project_path = Path.expand("lib/", path)
    rewrite_endpoint(path, project_path)
    path
  end

  defp rewrite_endpoint(path, project_path) do
    file = Path.expand("#{Macro.underscore(path)}_web/endpoint.ex", project_path)
    Mix.shell().info("Rewriting endpoint at '#{Path.relative_to_cwd(file)}' ...")
    lines = File.read!(file)

    # Replace `only` part to serve img instead of images
    lines =
      String.replace(
        lines,
        "only: ~w(css fonts images js favicon.ico robots.txt)",
        "only: ~w(css fonts img js favicon.ico robots.txt)"
      )

    File.write!(file, lines)
  end

  defp copy_template_files(path) do
    # Remove generated asset files
    asset_path = Path.expand("assets/", path)
    Mix.shell().info("Remove existing asset directory  '#{Path.relative_to_cwd(asset_path)}' ...")
    File.rm_rf!(asset_path)
    # Copy asset directory containing all vue frontend information
    Mix.shell().info("Copying asset directory to '#{Path.relative_to_cwd(asset_path)}' ...")
    File.cp_r("templates/vue/assets/", asset_path)

    # Replace web templates to support the vue js application (Add `app` div, change js and css in index.html)
    Mix.shell().info("Replacing web templates ...")
    project_path = Path.expand("lib/", path)
    web_path = Path.expand("#{Macro.underscore(path)}_web/", project_path)

    File.cp(
      "templates/vue/web/templates/layout/app.html.eex",
      Path.expand("templates/layout/app.html.eex", web_path)
    )

    File.cp(
      "templates/vue/web/templates/page/index.html.eex",
      Path.expand("templates/page/index.html.eex", web_path)
    )
  end
end
