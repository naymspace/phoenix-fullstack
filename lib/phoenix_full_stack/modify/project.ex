defmodule PhoenixFullStack.Modify.Project do
  @moduledoc false
  import PhoenixFullStack.Templates

  @source_prefix "project"
  @target_prefix "."

  def modify(path, template_bindings) do
    path = Path.join(path, @target_prefix)
    add_files(path, template_bindings)
  end

  defp add_files(path, template_bindings) do
    copy_file(
      @source_prefix <> "/docker-compose.override.templ.yml",
      path <> "/docker-compose.override.templ.yml"
    )

    eval_file(
      @source_prefix <> "/docker-compose.yml.exs",
      path <> "/docker-compose.yml",
      template_bindings
    )
  end
end
