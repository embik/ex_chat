defmodule ExChat.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :display_name, :string
      add :password_hash, :string

      timestamps()
    end

    create unique_index(:users, [:name])
  end
end
