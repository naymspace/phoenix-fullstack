defmodule PhoenixFullStack.Modify.Project do
  @moduledoc false
  import PhoenixFullStack.Templates

  @source_prefix "project"
  @target_prefix "./"

  def modify(path, template_bindings) do
    path = Path.expand(path, @target_prefix)
    add_files(path, template_bindings)
  end

  defp add_files(path, template_bindings) do
    eval_directory(@source_prefix, path, template_bindings)
  end
end
