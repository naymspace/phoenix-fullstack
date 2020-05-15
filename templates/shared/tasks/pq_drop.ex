defmodule Mix.Tasks.Ecto.PqDrop do
  use Mix.Task
  @shortdoc "Drops all tables in a Postgres database"

  @default_opts [yes: false]

  @aliases [
    y: :yes
  ]

  @switches [
    yes: :boolean
  ]

  @moduledoc """
  Because postgres uses connection and you cannot drop a complete database when there are connections, this tasks will
  instead drop all tables individually and ignoring foreign key checks.

  ## Command line options

    * `-y`, `--yes` - Skips the confirmation
  """

  def run(args) do
    {opts, _} = OptionParser.parse!(args, strict: @switches, aliases: @aliases)
    opts = Keyword.merge(@default_opts, opts)

    if !opts[:yes] && !Mix.shell().yes?("This will delete all data! Are you sure?") do
      Mix.shell().info("Ok - bye")
      exit({:shutdown, 1})
    end

    Mix.shell().info("Starting database connection...")
    # start the Repo for interacting with data
    Mix.Task.run("app.start")

    Mix.shell().info("Retrieving all tables from database...")

    table_names =
      Ted.Repo.query!(
        "SELECT table_name FROM information_schema.tables WHERE table_schema = (SELECT current_schema())"
      )
      |> Map.fetch!(:rows)
      |> Enum.concat()

    Mix.shell().info(
      "Dropping tables(#{length(table_names)}): \'#{Enum.join(table_names, "\', \'")}\' ..."
    )

    table_names
    |> Enum.map(fn table_name -> "DROP TABLE IF EXISTS #{table_name} CASCADE;" end)
    |> Enum.each(&Ted.Repo.query!/1)

    Mix.shell().info("All tables dropped!")
  end
end
