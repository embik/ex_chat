defmodule ExChatWeb.ChatController do
  use ExChatWeb, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: ExChatWeb.SessionHandler

  def chat(conn, _params) do
    render conn, "chat.html"
  end
end
