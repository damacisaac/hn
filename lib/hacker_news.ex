defmodule HackerNews do
  use HTTPoison.Base

  @expected_fields ~w(by descendants id kids score time  title type url)

  def process_url(url) do
    "https://hacker-news.firebaseio.com/v0/" <> url <> ".json"
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
  end
end