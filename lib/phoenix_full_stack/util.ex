defmodule PhoenixFullStack.Util do
  @moduledoc false

  @doc """
    List all files in a directory tree and returns them as a list.
  """
  def ls_r(path) do
    cond do
      File.regular?(path) ->
        [path]

      File.dir?(path) ->
        File.ls!(path)
        |> Stream.map(&Path.join(path, &1))
        |> Stream.map(&ls_r/1)
        |> Enum.concat()

      true ->
        []
    end
  end

  def temporary_directory(suffix \\ "") do
    dir = System.tmp_dir!()
    name = random_string() <> "_" <> suffix
    tmp_dir = Path.join(dir, name)
    File.mkdir_p!(tmp_dir)
    tmp_dir
  end

  def random_string(length \\ 8) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64() |> binary_part(0, length)
  end
end
