defmodule Marco.TweetImporter.ApiDatasource do
  import Ecto.Query, only: [from: 2]
  alias Marco.Repo

  def format_api_tweet(tweet) do
    %{
      tweet_id: tweet.id,
      twitter_user_id: tweet.user.id,
      tweeted_at: parse_date_into_ecto_datetime(tweet.created_at),
      favorite_count: tweet.favorite_count,
      retweet_count: tweet.retweet_count,
      in_reply_to_status_id: tweet.in_reply_to_status_id,
      text: tweet.text
    }
  end

  defp parse_date_into_ecto_datetime(string) do
    {:ok, timex_datetime} = Timex.parse(string, "%a %b %d %H:%M:%S +0000 %Y", :strftime)

    # maybe we lose timezone here ¯\_(ツ)_/¯
    {:ok, ecto_datetime} = Ecto.DateTime.cast(Timex.to_erlang_datetime(timex_datetime))
    ecto_datetime
  end

  def setup_credentials_for_user(user) do
    app_credentials = Map.new Application.get_env(:extwitter, :oauth, %{})
    user_credentials = %{
      access_token: user.twitter_access_token,
      access_token_secret: user.twitter_access_secret
    }
    ExTwitter.configure(:process, Map.merge(app_credentials, user_credentials))
  end

  # using this from t in Queryable thing feels like a huge hack
  def oldest_fetched_tweet_id(user) do
    from(t in Ecto.assoc(user, :tweets), order_by: [asc: t.tweet_id], limit: 1, select: t.tweet_id) |> Repo.one
  end

  def newest_fetched_tweet_id(user) do
    from(t in Ecto.assoc(user, :tweets), order_by: [desc: t.tweet_id], limit: 1, select: t.tweet_id) |> Repo.one
  end
end
