defmodule ExChatWeb.SessionController do
  use ExChatWeb, :controller

  require Logger

  alias ExChat.Accounts

  def login(conn, %{"session" => %{"username" => username, "password" => password}}) do
    case Accounts.verify_user_credentials(username, password) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Logged in.")
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: page_path(conn, :chat))
      {:error, message} ->
        Logger.info(message)
        conn
        |> redirect(to: page_path(conn, :index))
    end
  end
end
