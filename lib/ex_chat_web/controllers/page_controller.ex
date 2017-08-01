defmodule ExChatWeb.PageController do
  use ExChatWeb, :controller

  alias ExChat.Accounts.User

  def index(conn, _params) do
    case Guardian.Plug.current_resource(conn) do
      %User{} -> redirect(conn, to: chat_path(conn, :chat))
      _ -> render(conn, "index.html")
    end
  end

  def chat(conn, _params) do
    render conn, "chat.html"
  end
end
