defmodule PhoenixTemplate.Shared do
  @moduledoc """
  Rewrites generated Phoenix files that are important to every frontend
  """

  def run(path) do
    path
    |> rewrite()
    |> copy_template_files()
  end

  def rewrite(path) do
    project_path = Path.expand("lib/", path)
    rewrite_endpoint(path, project_path)
    rewrite_router(path, project_path)
    path
  end

  defp rewrite_endpoint(path, project_path) do
    file = Path.expand("#{Macro.underscore(path)}_web/endpoint.ex", project_path)
    Mix.shell().info("Rewriting endpoint at '#{Path.relative_to_cwd(file)}' ...")
    lines = File.read!(file)

    # Replace Gzip and Brotli compression
    lines = String.replace(lines, "gzip: false,", "gzip: true,\n    brotli: true,")

    # Replace `only` part to serve img instead of images
    lines =
      String.replace(
        lines,
        "only: ~w(css fonts images js favicon.ico robots.txt)",
        "only: ~w(css fonts img js favicon.ico robots.txt)"
      )

    File.write!(file, lines)
  end

  defp rewrite_router(path, project_path) do
    file = Path.expand("#{Macro.underscore(path)}_web/router.ex", project_path)
    Mix.shell().info("Rewriting router at '#{Path.relative_to_cwd(file)}' ...")
    lines = File.read!(file)

    # Allow frontend to use an internal router and go to sub pages like /about
    # This change will redirect even such request to the page controller and so to the frontend
    lines =
      String.replace(
        lines,
        "get \"/\", PageController, :index",
        "get \"/*page\", PageController, :index"
      )

    File.write!(file, lines)
  end

  def copy_template_files(path) do
    Mix.shell().info("Copying project files to '#{Path.relative_to_cwd(path)}' ...")
    File.cp_r("templates/shared/root", path)

    Mix.shell().info(
      "Copying configuration files to '#{Path.relative_to_cwd(Path.expand("config/", path))}' ..."
    )

    File.cp_r("templates/shared/config", Path.expand("config/", path))

    path
  end
end
