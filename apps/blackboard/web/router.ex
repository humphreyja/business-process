defmodule Blackboard.Router do
  use Blackboard.Web, :router

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

  scope "/", Blackboard do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/settings", PageController, :settings
    get "/editor", PageController, :editor
  end

  # Other scopes may use custom stacks.
  # scope "/api", Blackboard do
  #   pipe_through :api
  # end

  scope "/endpoints", Blackboard do
    pipe_through :api
    post "/:id", NodeEnpointController, :receive
  end
end
