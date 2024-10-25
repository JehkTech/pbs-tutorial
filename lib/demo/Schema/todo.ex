defmodule Demo.Schema.Todo do
  use Ecto.Schema
  import Ecto.Changeset
  alias Demo.Users.User
  

  schema "todos" do
    field :title, :string
    field :completed, :boolean, default: false
    belongs_to :user, User
    
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:title, :completed, :user_id])
    |> validate_required([:title, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
