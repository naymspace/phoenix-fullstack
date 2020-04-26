defmodule PhoenixTemplate.Templates do
  import Mix.Generator, only: [create_file: 3]

  @moduledoc """
  Module containing all files. A mix archive does not contain any non elixir files. So the files are read a at compile
  time and stored as module attributes.
  """

  @template_files [
    # Vue web
    "vue/web/templates/page/index.html.eex",
    "vue/web/templates/layout/app.html.eex",
    # Vue Assets
    "vue/assets/jest.config.js",
    "vue/assets/tests/unit/example.spec.ts",
    "vue/assets/public/favicon.ico",
    "vue/assets/babel.config.js",
    "vue/assets/.gitignore",
    "vue/assets/package-lock.json",
    "vue/assets/package.json",
    "vue/assets/vue.config.js",
    "vue/assets/.eslintrc.js",
    "vue/assets/tsconfig.json",
    "vue/assets/.eslintignore",
    "vue/assets/.browserslistrc",
    "vue/assets/src/App.vue",
    "vue/assets/src/main.ts",
    "vue/assets/src/scss/main.scss",
    "vue/assets/src/shims-tsx.d.ts",
    "vue/assets/src/components/HelloWorld.vue",
    "vue/assets/src/views/Home.vue",
    "vue/assets/src/views/About.vue",
    "vue/assets/src/assets/logo.png",
    "vue/assets/src/shims-vue.d.ts",
    "vue/assets/src/store/index.ts",
    "vue/assets/src/router/index.ts",
    # Project config
    "shared/config/dev.secret.exs",
    "shared/config/test.secret.exs",
    "shared/config/dev.exs",
    "shared/config/config.exs",
    "shared/config/prod.exs",
    "shared/config/test.exs",
    "shared/config/releases.exs",
    # Project root
    "shared/root/Dockerfile",
    "shared/root/mix.lock",
    "shared/root/Dockerfile_prod",
    "shared/root/README.md",
    "shared/root/.dockerignore",
    "shared/root/.gitignore",
    "shared/root/docker-compose.yml",
    # React Web
    "react/web/templates/page/index.html.eex",
    "react/web/templates/layout/app.html.eex",
    # React Assets
    "react/assets/.babelrc",
    "react/assets/css/app.css",
    "react/assets/css/phoenix.css",
    "react/assets/js/app.tsx",
    "react/assets/js/socket.js",
    "react/assets/webpack.config.js",
    "react/assets/package-lock.json",
    "react/assets/package.json",
    "react/assets/static/favicon.ico",
    "react/assets/static/images/phoenix.png",
    "react/assets/static/robots.txt",
    "react/assets/.prettierrc.js",
    "react/assets/tsconfig.json"
  ]
  root = Path.expand("../../templates", __DIR__)

  for source <- @template_files do
    @external_resource Path.join(root, source)
    defp render(unquote(source)), do: unquote(File.read!(Path.join(root, source)))
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
