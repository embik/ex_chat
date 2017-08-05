defmodule ExChat.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias ExChat.Accounts.User


  schema "users" do
    field :display_name, :string
    field :name, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :is_admin, :boolean

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :display_name, :password, :is_admin])
    |> validate_required([:name, :display_name, :is_admin])
    |> unique_constraint(:name)
    |> put_pass_hash
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true,
      changes: %{password: password}} = changeset) do
    if password != "" do
      change(changeset, Comeonin.Bcrypt.add_hash(password))
    end
  end
  defp put_pass_hash(changeset), do: changeset
end
