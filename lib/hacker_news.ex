defmodule HackerNews do
  use HTTPoison.Base

  @expected_fields ~w(by descendants id kids score time text title type url)

  def process_url(url) do
    "https://hacker-news.firebaseio.com/v0/" <> url <> ".json"
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
  end

  def get_path_from_id(id) do
    "item/" <> to_string(id)
  end

  def recursive_get_item_list(ids) do
    if not is_list ids do
      []
    else
      item_list = ids
      |> Enum.map(fn id -> get_path_from_id(id) end)
      |> Enum.map(fn path -> get_item(path) end)
      |> Enum.map(fn item -> List.insert_at(item, 0, {:children, recursive_get_item_list(item[:kids])}) end)
    end
  end

  def get_item(path) do 
    result = get!(path).body
    |> Enum.map(fn({k, v}) -> {String.to_atom(k), v} end)

    result
  end

  def get_items_from_id_list(list) do
    list 
    |> Enum.slice(0..29)
    |> Enum.map(fn id -> get_path_from_id(id) end)
    |> Enum.map(fn path -> get_item(path) end)
  end

  def get_new_stories() do
    response = get! "newstories"
    get_items_from_id_list response.body
  end

  def get_top_stories() do
    response = get! "topstories"
    get_items_from_id_list response.body
  end

  def get_ask_stories() do
    response = get! "askstories"
    get_items_from_id_list response.body
  end

  def get_job_stories() do
    response = get! "jobstories"
    get_items_from_id_list response.body
  end
    
  def get_show_stories() do
    response = get! "showstories"
    get_items_from_id_list response.body
  end

  def get_details(id) do
    path = get_path_from_id(id)
    get_item(path)
  end
end