defmodule <%= app_module %>.Release do
  @moduledoc """
    Module containing the necessary commands to execute in a production environment.
    See https://hexdocs.pm/phoenix/releases.html#ecto-migrations-and-custom-commands for details and reasons.
  """
  @app :<%= app_name %>

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end
end
