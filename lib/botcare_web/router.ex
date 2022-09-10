defmodule BotcareWeb.Router do
  use BotcareWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {BotcareWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :auth do
    plug :basic_auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BotcareWeb do
    pipe_through [:browser, :auth]

    live "/", BotLive.Index, :index
    live "/bots/new", BotLive.Index, :new
    live "/bots/:id/edit", BotLive.Index, :edit

    live "/bots/:id", BotLive.Show, :show
    live "/bots/:id/show/edit", BotLive.Show, :edit
  end

  scope "/", BotcareWeb do
    pipe_through [:api]
    post "/maintenance", WebhookController, :maintenance

    # temp for testing
    post "/active", WebhookController, :active
  end

  # Other scopes may use custom stacks.
  # scope "/api", BotcareWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BotcareWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  defp basic_auth(conn, _opts) do
    username = System.fetch_env!("BASIC_AUTH_USERNAME")
    password = System.fetch_env!("BASIC_AUTH_PASSWORD")
    Plug.BasicAuth.basic_auth(conn, username: username, password: password)
  end
end
