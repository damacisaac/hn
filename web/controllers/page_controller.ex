defmodule Hn.PageController do
  require Logger

  use Hn.Web, :controller

  def get_path_from_id(id) do
    "item/" <> to_string(id)
  end

  def recursive_get_item_list(ids) do
    if not is_list ids do
      []
    else
      item_list = ids
      |> Enum.map(fn id -> Hn.PageController.get_path_from_id(id) end)
      |> Enum.map(fn path -> Hn.PageController.get_item(path) end)
      |> Enum.map(fn item -> List.insert_at(item, 0, {:children, recursive_get_item_list(item[:kids])}) end)
    end
  end

  def get_item(path) do 
    result = HackerNews.get!(path).body
    |> Enum.map(fn({k, v}) -> {String.to_atom(k), v} end)

    result
  end

  def index(conn, params) do
    p = Dict.get(params, "p", "1")
    {next_page, _} = Integer.parse(p)
    next_page = next_page + 1

    response = HackerNews.get! "topstories"

    top_stories = response.body
    |> Enum.slice(0..29)
    |> Enum.map(fn id -> Hn.PageController.get_path_from_id(id) end)
    |> Enum.map(fn path -> Hn.PageController.get_item(path) end)

    render conn, "index.html", top_stories: top_stories, next_page: next_page 
  end

  def show(conn, %{"id" => id}) do
    path = Hn.PageController.get_path_from_id(id)

    story = get_item(path)

    comments = Hn.PageController.recursive_get_item_list story[:kids]

    render conn, "details.html", story: story, comments: comments
  end
end
