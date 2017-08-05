defmodule ExChatWeb.SessionHandler do
  import ExChatWeb.Router.Helpers
  import Phoenix.Controller

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "You need to be authenticated.")
    |> redirect(to: page_path(conn, :index))
  end

  def unauthorized(conn, _params) do
    conn
    |> put_flash(:error, "You are not authorized for this.")
    |> redirect(to: page_path(conn, :index))
  end
end
