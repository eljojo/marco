defmodule Marco.TweetTest do
  use Marco.ModelCase

  alias Marco.Tweet

  @valid_attrs %{favorite_count: 42, fetched_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, in_reply_to_status_id: 42, lang: "some content", retweet_count: 42, text: "some content", tweet_id: 42, tweeted_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Tweet.changeset(%Tweet{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Tweet.changeset(%Tweet{}, @invalid_attrs)
    refute changeset.valid?
  end
end
