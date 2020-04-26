defmodule PhoenixTemplate.Shared do
  @moduledoc """
  Rewrites generated Phoenix files that are important to every frontend
  """

  import PhoenixTemplate.Templates, only: [copy_directory: 2, eval_directory: 3]

  def run(path, template_bindings) do
    path
    |> rewrite()
    |> copy_template_files(template_bindings)
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

  defp copy_template_files(path, template_bindings) do
    Mix.shell().info("Copying project files to '#{Path.relative_to_cwd(path)}' ...")
    copy_directory("shared/root/", path)

    Mix.shell().info(
      "Copying configuration files to '#{Path.relative_to_cwd(Path.expand("config/", path))}' ..."
    )

    config_files(path, template_bindings)

    Mix.shell().info("Removing unnecessary prod.secret.exs ...")
    File.rm!(Path.expand("config/prod.secret.exs", path))

    path
  end

  defp config_files(path, template_bindings) do
    config_path = Path.expand("config/", path)
    eval_directory("shared/config/", config_path, template_bindings)
#    template_path = "templates/shared/config/"
#
#    File.ls!(template_path)
#    |> Enum.map(fn file -> Path.expand(file, template_path) end)
#    |> Enum.each(fn file ->
#      content = EEx.eval_file(file, template_bindings)
#      config_file = Path.expand(Path.basename(file), config_path)
#      File.write!(config_file, content)
#    end)
  end
end
