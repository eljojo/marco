defmodule Marco.TweetImporter do
  import Ecto.Query, only: [from: 2]

  alias Marco.Repo
  alias Marco.Tweet

  def import_tweets(user) do
    setup_credentials_for_user(user)
    # search_for_user(user) |> Enum.map(&persist_tweet(&1, user))
    get_user_timeline(user) |> Enum.map(&persist_tweet(&1, user))
  end

  defp search_for_user(user) do
    ExTwitter.search("from:#{user.twitter_handle}", [count: 100, max_id: last_fetched_twitter_id(user)])
  end

  defp get_user_timeline(user) do
    ExTwitter.user_timeline([count: 200, max_id: last_fetched_twitter_id(user)])
  end

  defp persist_tweet(tweet, user) do
    params = %{
      tweet_id: tweet.id,
      twitter_user_id: tweet.user.id,
      tweeted_at: parse_date_into_ecto_datetime(tweet.created_at),
      favorite_count: tweet.favorite_count,
      retweet_count: tweet.retweet_count,
      in_reply_to_status_id: tweet.in_reply_to_status_id,
      text: tweet.text
    }

    model = Repo.get_by(Tweet, tweet_id: params.tweet_id) || Ecto.build_assoc(user, :tweets)
    changeset = Tweet.changeset(model, params)
    Repo.insert_or_update(changeset)
  end

  defp parse_date_into_ecto_datetime(string) do
    {:ok, timex_datetime} = Timex.parse(string, "%a %b %d %H:%M:%S +0000 %Y", :strftime)
    # maybe we loose timezone here :shrugs:
    {:ok, ecto_datetime} = Ecto.DateTime.cast(Timex.to_erlang_datetime(timex_datetime))
    ecto_datetime
  end

  defp setup_credentials_for_user(user) do
    app_credentials = Application.get_env(:extwitter, :oauth, %{})
    user_credentials = %{
      access_token: user.twitter_access_token,
      access_token_secret: user.twitter_access_secret
    }
    ExTwitter.configure(:process, Map.merge(app_credentials, user_credentials))
  end

  defp last_fetched_twitter_id(user) do
    from(t in Ecto.assoc(user, :tweets), order_by: [asc: t.tweet_id], limit: 1, select: t.tweet_id) |> Repo.one
  end
end
