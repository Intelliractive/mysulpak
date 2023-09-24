defmodule MysulpakWeb.Router do
  alias MysulpakWeb.Layouts
  use MysulpakWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {MysulpakWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MysulpakWeb do
    pipe_through :browser

    # get "/", PageController, :home

    live_session :store, root_layout: {Layouts, :sulpak} do
      live "/items", ItemLive.Index, :index
      live "/items/new", ItemLive.Index, :new
      live "/items/:id/edit", ItemLive.Index, :edit

      live "/items/:id", ItemLive.Show, :show
      live "/items/:id/show/edit", ItemLive.Show, :edit
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", MysulpakWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:mysulpak, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: MysulpakWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
