defmodule ExChatWeb.SessionHandler do
  import ExChatWeb.Router.Helpers

  alias Phoenix.Controller

  def unauthenticated(conn, _params) do
    conn
    |> Controller.put_flash(:error, "You need to be authenticated.")
    |> Controller.redirect(to: page_path(conn, :index))
  end
end
