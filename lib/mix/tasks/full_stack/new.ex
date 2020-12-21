defmodule Mix.Tasks.FullStack.New do
  use Mix.Task
  @shortdoc "Creates a ready to use full stack application based on Phoenix."

  @moduledoc """
  Creates a ready to use full stack application based on Phoenix and deploy at production.

  It expects the path of the project as an argument.
      mix full_stack.new PATH [OPTIONS]

  Contains the database layer Ecto in combination with Postgres.

  The application will contain a functional Docker build for development and production. The development will contain
  a functional docker-compose.

  The configuration are mostly the default Phoenix ones with adaption to work with the Frontend technologies.
  """

  @version Mix.Project.config()[:version]

  def run([version]) when version in ~w(-v --version) do
    Mix.shell().info("PhoenixFullStack v#{@version}")
  end

  def run(args) do
    path = hd(args)

    bindings = template_bindings(path)

    # Generate Phoenix project
    Mix.Task.run("phx.new", [path])

    Mix.shell().info("Finished!")
  end

  defp template_bindings(path) do
    app_name = Path.basename(path) |> String.downcase()
    [
      app_name: app_name,
      app_module:  Macro.camelize(app_name),
      web_module: "#{Macro.camelize(app_name)}Web"
    ]
  end
end
