defmodule Mix.Tasks.FullStack.New do
  use Mix.Task
  @shortdoc "Creates a ready to use full stack application based on Phoenix."

  @moduledoc """
  Creates a ready to use full stack application based on Phoenix and deploy at production.

  It expects the path of the project as an argument.
      mix full_stack.new PATH [OPTIONS]

  Contains the database layer Ecto in combination with Postgres. You can decide the frontend technology - Vue or
  React (not yet implemented).

  The application will contain a functional Docker build for development and production. The development will contain
  a functional docker-compose.

  The configuration are mostly the default Phoenix ones with adaption to work with the Frontend technologies.

  ## Command line options
    * `--frontend` - The frontend technology to use. One of:
      * `vue` - Vue 2 with Vuex, Router and Typescript. Compatible with the Vue-Cli
      * `react` - **NOT YET IMPLEMENTED**
      * `elm` - **NOT YET IMPLEMENTED**
  """

  @version Mix.Project.config()[:version]

  @aliases [
    f: :frontend
  ]

  @switches [
    frontend: :string
  ]

  def run([version]) when version in ~w(-v --version) do
    Mix.shell().info("FullStack v#{@version}")
  end

  def run(args) do
    {opts, args} = parse_opts(args)
    frontend = opts[:frontend]
    validate_frontend!(frontend)
    path = hd(args)

    # Generate Phoenix project
    Mix.Task.run("phx.new", [path])

    # General operation
    PhoenixTemplate.Shared.run(path)

    # TODO: Add elm and react support
    case frontend do
      "vue" -> PhoenixTemplate.Vue.run(path)
    end

    Mix.shell().info("Finished!")
  end

  defp parse_opts(argv) do
    case OptionParser.parse(argv, strict: @switches, aliases: @aliases) do
      {opts, argv, []} ->
        {opts, argv}

      {_opts, _argv, [switch | _]} ->
        Mix.raise("Invalid option: " <> switch_to_string(switch))
    end
  end

  defp switch_to_string({name, nil}), do: name
  defp switch_to_string({name, val}), do: name <> "=" <> val

  defp validate_frontend!(frontend) when is_nil(frontend) or frontend == "" do
    Mix.raise("You need to choose a frontend with --frontend [vue|react]")
  end

  defp validate_frontend!(frontend) do
    case frontend do
      "vue" ->
        nil

      "react" ->
        Mix.raise("React as frontend not yet implemented!")

      "elm" ->
        Mix.raise("Elm as frontend not yet implemented!")

      unknown ->
        Mix.raise("Unknown frontend " <> unknown)
    end
  end
end
