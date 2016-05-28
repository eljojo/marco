defmodule Marco.TweetImporter.ApiDatasource do
  require Logger
  alias Marco.TweetImporter.ApiDatasource.Search
  alias Marco.TweetImporter.ApiDatasource.Timeline

  def get_tweets(user, source) when is_atom(source) do
    case source do
      :search -> get_tweets(user, &Search.query_api/2)
      :timeline -> get_tweets(user, &Timeline.query_api/2)
    end
  end

  def get_tweets(user, query_function) when is_function(query_function) do
    setup_credentials_for_user(user)

    Stream.unfold(nil, &do_get_tweets(&1, user, query_function))
    |> Stream.flat_map(&(&1)) # this hack (?) flattens the results
    |> Stream.map(&format_api_tweet(&1))
  end

  defp do_get_tweets(max_id, user, query_function) when is_integer(max_id) or is_nil(max_id) do
    opts = if max_id do %{max_id: max_id} else %{} end
    case query_function.(user, opts) do
      {:ok, tweets} ->
        if length(tweets) > 1 do
          new_max_id = tweets |> Enum.map(&(&1.id)) |> Enum.min()
          {tweets, new_max_id}
        else
          {tweets, :end}
        end
      {:error, _} ->
        {[], :end}
    end
  end

  defp do_get_tweets(:end, _, _), do: nil

  defp format_api_tweet(tweet) do
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

  defp setup_credentials_for_user(user) do
    app_credentials = Map.new Application.get_env(:extwitter, :oauth, %{})
    user_credentials = %{
      access_token: user.twitter_access_token,
      access_token_secret: user.twitter_access_secret
    }
    ExTwitter.configure(:process, Map.merge(app_credentials, user_credentials))
  end
end
