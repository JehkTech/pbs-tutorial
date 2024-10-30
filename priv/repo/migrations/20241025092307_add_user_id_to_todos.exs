defmodule Demo.Repo.Migrations.AddUserIdToTodos do
  use Ecto.Migration

  def change do
    alter table(:todos) do
      add :user_id, references(:users, type: :id, on_delete: :delete_all), null: false
    end

    create index(:todos, [:user_id])
  end

  def down do
    alter table(:todos) do 
      remove :user_id
    end
  end
end
