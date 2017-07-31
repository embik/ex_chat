defmodule ExChat.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias ExChat.Accounts.User


  schema "users" do
    field :display_name, :string
    field :name, :string
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :display_name, :password_hash])
    |> validate_required([:name, :display_name, :password_hash])
    |> unique_constraint(:name)
  end
end
