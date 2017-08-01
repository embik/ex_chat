defmodule ExChatWeb.Router do
  use ExChatWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ExChatWeb do
    pipe_through [:browser, :browser_session]

    get "/", PageController, :index
    get "/chat", ChatController, :chat
  end

  scope "/auth", ExChatWeb do
    pipe_through :browser

    post "/login", SessionController, :login
  end

  scope "/admin", ExChatWeb do
    pipe_through :browser

    resources "/users", UserController
  end


  # Other scopes may use custom stacks.
  # scope "/api", ExChatWeb do
  #   pipe_through :api
  # end
end
