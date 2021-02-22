defmodule <%= app_module %>.Repo do
  use Ecto.Repo,
      otp_app: :<%= app_name %>,
      adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 25

  # Necessary to read the database url at runtime instead of compile time
  def init(_type, config) do
    {:ok, Keyword.put(config, :url, System.get_env("DATABASE_URL"))}
  end

  alias Ecto.Changeset

  @doc """
  Get an entity from the database. Returns {:ok, entity} if found, otherwise a {:error, %Ecto.Changeset{}}.

  This can be used in a with-case to propagate an error in the controller to the client (not found)

  ## Examples

      iex> get_or_error(Manufacturer, 10)
      {:ok, %Manufacturer{}}

      iex> get_or_error(Manufacturer, -1)
      {:error, %Ecto.Changeset{}}

  """
  def get_or_error(queryable, id) do
    case <%= app_module %>.Repo.get(queryable, id) do
      nil ->
        {
          :error,
          queryable
          |> Kernel.struct()
          |> Changeset.change()
          |> Changeset.add_error(:id, "%{type} with id %{id} not found",
               type: List.last(Module.split(queryable)),
               id: id
             )
        }

      record ->
        {:ok, record}
    end
  end

  @doc """
  Get an entity by an attribute from the database. Returns {:ok, entity} if found, otherwise a {:error, %Ecto.Changeset{}}.

  It wraps around &Ecto.Repo.get_by/2.

  This can be used in a with-case to propagate an error in the controller to the client (not found)

  ## Examples

      iex> get_by_or_error(Booking, :booking_uuid, 10)
      {:ok, %Booking{}}

      iex> get_by_or_error(Booking, :booking_uuid, -1)
      {:error, %Ecto.Changeset{}}

  """
  def get_by_or_error(queryable, attr, value) do
    case <%= app_module %>.Repo.get_by(queryable, [{attr, value}]) do
      nil ->
        {
          :error,
          queryable
          |> Kernel.struct()
          |> Changeset.change()
          |> Changeset.add_error(attr, "%{type} with '#{attr}' = '#{value}' not found",
               type: List.last(Module.split(queryable))
             )
        }

      record ->
        {:ok, record}
    end
  end
end
