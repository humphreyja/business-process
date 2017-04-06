defmodule SSO.Router do
  use SSO.Web, :router
  use ExAdmin.Router
  use Coherence.Router

  pipeline :public do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Plug.Parsers, parsers: [:urlencoded]
    plug SSO.Plugs.CaptureParams
    plug Coherence.Authentication.Session
    plug SSO.Plugs.SignedOutCatchAndRedirect
  end

  pipeline :protected do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Plug.Parsers, parsers: [:urlencoded]
    plug SSO.Plugs.CaptureParams
    plug Coherence.Authentication.Session, protected: true
    plug SSO.Plugs.ClientRedirect
  end

  pipeline :protected_admin do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session, protected: true
    plug SSO.Plugs.Authorized
  end

  scope "/" do
    pipe_through :public
    coherence_routes :public

    get "/sign-out", Coherence.SessionController, :delete
  end

  scope "/" do
    pipe_through :protected
    coherence_routes :protected
  end

  scope "/" do
    pipe_through :protected_admin
    coherence_routes :protected_admin
  end

  scope "/", SSO do
    pipe_through :protected

    get "/", ClientsController, :index
  end

  scope "/admin", ExAdmin do
    pipe_through :protected_admin
    admin_routes
  end
end
