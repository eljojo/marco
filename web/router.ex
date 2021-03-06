defmodule Marco.Router do
  use Marco.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/auth", Marco do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    delete "/logout", AuthController, :delete
  end

  scope "/", Marco do
    pipe_through :browser # Use the default browser stack

    resources "/users", UserController

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Marco do
  #   pipe_through :api
  # end
end
