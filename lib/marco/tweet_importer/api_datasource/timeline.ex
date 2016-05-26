defmodule Marco.TweetImporter.ApiDatasource.Timeline do
  alias Marco.TweetImporter.ApiDatasource

  import ApiDatasource, only: [
    format_api_tweet: 1, oldest_fetched_tweet_id: 1,
    newest_fetched_tweet_id: 1, setup_credentials_for_user: 1
  ]

  def get_tweets(user) do
    setup_credentials_for_user(user)
    ExTwitter.user_timeline([count: 200, max_id: oldest_fetched_tweet_id(user)]) |> Stream.map(&format_api_tweet(&1))
  end
end
