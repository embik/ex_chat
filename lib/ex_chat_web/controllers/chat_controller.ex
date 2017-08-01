defmodule ExChatWeb.ChatController do
  use ExChatWeb, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: ExChatWeb.SessionHandler

  def chat(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    render(conn, "chat.html", user: user)
  end
end
