defmodule Demo.Todos do
  @moduledoc """
  The Todos context.
  """

  alias Demo.Repo
  alias Demo.Schema.Todo

# Subscribe
  def subscribe do
    Phoenix.PubSub.subscribe(Demo.PubSub, "todos")
  end
  defp broadcast_change({:ok, todo} =result, event) do
    Phoenix.PubSub.broadcast(Demo.PubSub, "todos", {__MODULE__, event, todo})
    result
  end
  defp broadcast_change(todo, _event), do: todo
  # def change_todo(%Todo{} = todo, attrs \\ %{}) do
  #   Todo.changeset(todo, attrs)
  # end


  @doc """
  Returns the list of todos.

  ## Examples

      iex> list_todos()
      [%Todo{}, ...]

  """
  def list_todos do
    Repo.all(Todo)
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
  def get_todo!(id) do
   Repo.get!(Todo, id)
  end

  @doc """
  Creates a todo.

  ## Examples

      iex> create_todo(%{field: value})
      {:ok, %Todo{}}

      iex> create_todo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_todo(attrs \\ %{}) do
    %Todo{}
    |> Todo.changeset(attrs)
    |> Repo.insert()
    |> broadcast_change([:todo, :created])
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
    |> broadcast_change([:todo, :updated])
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
    |> broadcast_change([:todo, :deleted])
  end

  # @doc """
  # Returns an `%Ecto.Changeset{}` for tracking todo changes.

  # ## Examples

  #     iex> change_todo(todo)
  #     %Ecto.Changeset{data: %Todo{}}

  # """
  
  
end
