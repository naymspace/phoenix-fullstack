defmodule Mix.Tasks.Version do
  use Mix.Task
  @shortdoc "Prints the version of the main application"

  def run(_) do
    Mix.Shell.IO.info(PhoenixFullStack.MixProject.project[:version])
  end

end
