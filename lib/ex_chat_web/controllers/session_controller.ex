defmodule ExChatWeb.SessionController do
  use ExChatWeb, :controller

  require Logger

  alias ExChat.Accounts

  def login(conn, %{"session" => %{"username" => username, "password" => password}}) do
    case Accounts.verify_user_credentials(username, password) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Logged in.")
        |> Guardian.Plug.sign_in(user, :access, perms: Accounts.get_perms(user))
        |> redirect(to: chat_path(conn, :chat))
      {:error, message} ->
        Logger.info(message)
        conn
        |> put_flash(:error, "Failed to log in.")
        |> redirect(to: page_path(conn, :index))
    end
  end

  def logout(conn, _params) do
    conn
    |> put_flash(:info, "Logged out.")
    |> Guardian.Plug.sign_out
    |> redirect(to: page_path(conn, :index))
  end
end
