defmodule Demo.Todos do
  @moduledoc """
  The Todos context.
  """

  import Ecto.Query, warn: false
  alias Demo.Schema.Todo
  alias Demo.Repo
  
    

# Subscribe
  def subscribe(user_id) do
    Phoenix.PubSub.subscribe(Demo.PubSub, "todos:#{user_id}")
  end

  @doc """
  Returns the list of todos.

  ## Examples

      iex> list_todos()
      [%Todo{}, ...]

  """
  def list_todos(user_id) do
  Todo
  |> where(user_id: ^user_id)
  |> Repo.all()
  end

  @doc """
  Gets a single todo.

  Raises `Ecto.NoResultsError` if the Todo does not exist.

  ## Examples

      iex> get_todo!(123)
      %Todo{}

      iex> get_todo!(456)
      ** (Ecto.NoResultsError)

  """
  def get_todo!(id, user_id) do
    Todo
    |> where(user_id: ^user_id)
    |> Repo.get!(id)
  end

  @doc """
  Creates a todo.

  ## Examples

      iex> create_todo(%{field: value})
      {:ok, %Todo{}}

      iex> create_todo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_todo(attrs \\ %{}, user_id) do

    attrs = Map.put(attrs, "user_id", user_id)

    %Todo{}
    |> Todo.changeset(attrs)
    |> Repo.insert()
    |> broadcast_change([:todo, :created], user_id)
  end

  @doc """
  Updates a todo.

  ## Examples

      iex> update_todo(todo, %{field: new_value})
      {:ok, %Todo{}}

      iex> update_todo(todo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_todo(%Todo{} = todo, attrs) do
    todo
    |> Todo.changeset(attrs)
    |> Repo.update()
    |> broadcast_change([:todo, :updated], todo.user_id)
  end

  @doc """
  Deletes a todo.

  ## Examples

      iex> delete_todo(todo)
      {:ok, %Todo{}}

      iex> delete_todo(todo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_todo(%Todo{} = todo) do
    Repo.delete(todo)
    |> broadcast_change([:todo, :deleted], todo.user_id)
  end

  # @doc """
  # Returns an `%Ecto.Changeset{}` for tracking todo changes.

  # ## Examples

  #     iex> change_todo(todo)
  #     %Ecto.Changeset{data: %Todo{}}

  # """
  defp broadcast_change({:ok, todo} =result, event, user_id) do
    Phoenix.PubSub.broadcast(
      Demo.PubSub, 
      "todos:#{user_id}",
      {__MODULE__, event, todo}
      )
    result
  end
  defp broadcast_change(result, _event, _user_id), do: result
  # def change_todo(%Todo{} = todo, attrs \\ %{}) do
  #   Todo.changeset(todo, attrs)
  # end
  
end
