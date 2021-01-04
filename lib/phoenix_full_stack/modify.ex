defmodule PhoenixFullStack.Modify do
  @moduledoc false

  def modify(path, template_bindings) do
    PhoenixFullStack.Modify.Phoenix.modify(path, template_bindings)
  end
end
