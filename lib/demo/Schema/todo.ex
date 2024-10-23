defmodule Demo.Schema.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todos" do
    field :completed, :boolean, default: false
    field :title, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:title, :completed])
    |> validate_required([:title])
  end
end
