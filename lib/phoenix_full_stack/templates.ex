defmodule PhoenixFullStack.Templates do
  import Mix.Generator, only: [create_file: 3]

  @moduledoc """
  Module containing all files. A mix archive does not contain any non elixir files. So the files are read a at compile
  time and stored as module attributes.
  """

  @root Path.expand("../../templates", __DIR__)
  @template_files PhoenixFullStack.Util.ls_r(@root)

  for source_file <- @template_files do
    # Remove unnecessary prefix for easier method invocation
    source = String.replace(source_file, @root <> "/", "")
    @external_resource source_file
    defp render(unquote(source)), do: unquote(File.read!(source_file))
  end

  @doc """

    copy_directory("react/assets", "project/assets")
  """

  def copy_directory(directory, target_root) do
    @template_files
    |> Stream.filter(fn path -> String.starts_with?(path, directory) end)
    |> Stream.map(fn path ->
      target_file = String.replace_prefix(path, directory, "")
      {path, target_file}
    end)
    |> Enum.each(fn {path, target_file} ->
      target_file = Path.expand(target_file, target_root)
      File.mkdir_p!(Path.dirname(target_file))
      create_file(target_file, render(path), force: true)
    end)
  end

  def copy_file(file, target_file) do
    File.mkdir_p!(Path.dirname(target_file))
    create_file(target_file, render(file), force: true)
  end

  def eval_file(file, target_file, bindings) do
    File.mkdir_p!(Path.dirname(target_file))
    content = EEx.eval_string(render(file), bindings)
    create_file(target_file, content, force: true)
  end

  def eval_directory(directory, target_root, bindings) do
    @template_files
    |> Stream.filter(fn path -> String.starts_with?(path, directory) end)
    |> Stream.map(fn path ->
      target_file = String.replace_prefix(path, directory, "")
      {path, target_file}
    end)
    |> Enum.each(fn {path, target_file} ->
      content = EEx.eval_string(render(path), bindings)
      target_file = Path.expand(target_file, target_root)
      File.mkdir_p!(Path.dirname(target_file))
      create_file(target_file, content, force: true)
    end)
  end
end
