defmodule ExChat.Chats.Room do
  use Ecto.Schema
  import Ecto.Changeset
  alias ExChat.Chats.Room


  schema "rooms" do
    field :name, :string
    field :public, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(%Room{} = room, attrs) do
    room
    |> cast(attrs, [:name, :public])
    |> validate_required([:name, :public])
    |> unique_constraint(:name)
  end
end
