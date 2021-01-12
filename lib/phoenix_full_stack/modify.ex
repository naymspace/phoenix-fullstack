defmodule PhoenixFullStack.Modify do
  @moduledoc false

  def modify(path, template_bindings) do
    Mix.shell().info("Phoenix modifications...")
    PhoenixFullStack.Modify.Phoenix.modify(path, template_bindings)
    Mix.shell().info("Main project modifications...")
    PhoenixFullStack.Modify.Project.modify(path, template_bindings)
  end
end
