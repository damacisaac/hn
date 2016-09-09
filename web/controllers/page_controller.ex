defmodule Hn.PageController do
  require Logger

  use Hn.Web, :controller

  def get_story(path) do 
    HackerNews.get!(path).body
    |> Enum.map(fn({k, v}) -> {String.to_atom(k), v} end)
  end

  def index(conn, _params) do
    response = HackerNews.get! "topstories"

    top_stories = response.body
    |> Enum.slice(0..9)
    |> Enum.map(fn id -> ("item/" <> to_string(id)) end)
    |> Enum.map(fn path -> Hn.PageController.get_story(path) end)

    render conn, "index.html", top_stories: top_stories
  end
end
