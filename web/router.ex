defmodule Hn.Router do
  use Hn.Web, :router

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

  scope "/", Hn do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/news", PageController, :index
    get "/new", PageController, :new
    get "/jobs", PageController, :jobs
    get "/ask", PageController, :ask
    get "/show", PageController, :show
    get "/item/:id", PageController, :show
  end
end
