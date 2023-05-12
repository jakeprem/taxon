defmodule TaxonWeb.Router do
  use TaxonWeb, :router

  import TaxonWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TaxonWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TaxonWeb do
    pipe_through :browser

    # get "/", Redirect, to: "/links"
    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", TaxonWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:taxon, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TaxonWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", TaxonWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{TaxonWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", TaxonWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{TaxonWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email

      live "/links", LinkLive.Index, :index
      live "/links/new", LinkLive.Index, :new
      live "/links/:id/edit", LinkLive.Index, :edit

      live "/links/:id", LinkLive.Show, :show
      live "/links/:id/show/edit", LinkLive.Show, :edit

      live "/invite_codes", InviteCodeLive.Index, :index
      live "/invite_codes/new", InviteCodeLive.Index, :new
      live "/invite_codes/:id/edit", InviteCodeLive.Index, :edit

      live "/invite_codes/:id", InviteCodeLive.Show, :show
      live "/invite_codes/:id/show/edit", InviteCodeLive.Show, :edit
    end
  end

  scope "/", TaxonWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{TaxonWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end

  # Last of all, anything that doesn't match above will do the actual link lookup
  scope "/", TaxonWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/*path", PageController, :stuff
  end
end
