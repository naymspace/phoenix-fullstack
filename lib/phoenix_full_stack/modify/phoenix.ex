defmodule PhoenixFullStack.Modify.Phoenix do
  @moduledoc false
  import PhoenixFullStack.Templates

  def modify(path) do
    rewrite_mix_file(path)
    add_files(path)
  end

  defp rewrite_mix_file(path) do
    file = Path.expand("mix.exs", path)
    Mix.shell().info("Rewriting mix.exs at '#{Path.relative_to_cwd(file)}' ...")
    lines = File.read!(file)

    # Replace default
    lines =
      String.replace(
        lines,
        ~r/defp aliases do\s+\[.*\]\s+end/s,
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

    File.write!(file, lines)
  end

  @template_files_path "backend/phoenix/"

  defp add_files(path) do
    copy_file(".keepdir", path)
  end
end
