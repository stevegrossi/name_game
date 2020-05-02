defmodule NameGameWeb.Router do
  use NameGameWeb, :router
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_root_layout, {NameGameWeb.LayoutView, :root}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NameGameWeb do
    pipe_through :browser

    live "/", FlashCardsLive

    # For a real app, this would be behind authentication 😅
    live_dashboard "/dashboard", metrics: NameGameWeb.Telemetry
  end
end
