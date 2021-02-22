defmodule <%= app_module %>.Factory do
  @moduledoc """
    A module loading the other factories
  """
  use ExMachina.Ecto, repo: <%= app_module %>.Repo

  alias <%= app_module %>.Factory

  # Add your factories here
  # Example:
  #
  #  use Factory.{
  #    AssetFactory
  #  }
end
