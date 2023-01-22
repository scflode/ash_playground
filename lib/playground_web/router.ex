defmodule PlaygroundWeb.Router do
  use PlaygroundWeb, :router
  use AshAuthentication.Phoenix.Router

  import AshAdmin.Router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {PlaygroundWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:load_from_session)
  end

  pipeline :api do
    plug(:accepts, ["json"])
    plug(:load_from_bearer)
  end

  scope "/", PlaygroundWeb do
    pipe_through(:browser)

    sign_in_route(path: "/login")
    sign_out_route(AuthController, "/logout")
    auth_routes_for(Playground.Accounts.User, to: AuthController, path: "/auth")
    reset_route()

    get("/", PageController, :home)
  end

  scope "/" do
    pipe_through(:browser)

    ash_admin("/admin")
  end

  # Other scopes may use custom stacks.
  # scope "/api", PlaygroundWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:playground, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: PlaygroundWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end
