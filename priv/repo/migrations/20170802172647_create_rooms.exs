defmodule ExChat.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :string
      add :public, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:rooms, [:name])
  end
end
