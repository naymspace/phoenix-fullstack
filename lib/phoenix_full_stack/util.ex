defmodule PhoenixFullStack.Util do
  @moduledoc false

  @doc """
    List all files in a directory tree and returns them as a list.
  """
  def ls_r(path) do
    cond do
      File.regular?(path) -> [path]
      File.dir?(path) ->
        File.ls!(path)
        |> Stream.map(&Path.join(path, &1))
        |> Stream.map(&ls_r/1)
        |> Enum.concat
      true -> []
    end
  end

end
