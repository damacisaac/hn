defmodule Hn.PageController do
  require Logger

  use Hn.Web, :controller

  def get_next_page(params) do
    p = Dict.get(params, "p", "1")
    {next_page, _} = Integer.parse(p)
    next_page + 1
  end

  def index(conn, params) do
    next_page = Hn.PageController.get_next_page(params)
    stories = HackerNews.get_top_stories()
    render conn, "index.html", stories: stories, next_page: next_page 
  end

  def show(conn, %{"id" => id}) do
    story = HackerNews.get_details(id)
    comments = HackerNews.recursive_get_item_list story[:kids]
    render conn, "details.html", story: story, comments: comments
  end

  def ask(conn, params) do
    next_page = Hn.PageController.get_next_page(params)
    stories = HackerNews.get_ask_stories()
    render conn, "index.html", stories: stories, next_page: next_page 
  end

  def jobs(conn, params) do
    next_page = Hn.PageController.get_next_page(params)
    stories = HackerNews.get_job_stories()
    render conn, "index.html", stories: stories, next_page: next_page 
  end

  def new(conn, params) do
    next_page = Hn.PageController.get_next_page(params)
    stories = HackerNews.get_new_stories()
    render conn, "index.html", stories: stories, next_page: next_page 
  end

  def show(conn, params) do
    next_page = Hn.PageController.get_next_page(params)
    stories = HackerNews.get_show_stories()
    render conn, "index.html", stories: stories, next_page: next_page 
  end
end
