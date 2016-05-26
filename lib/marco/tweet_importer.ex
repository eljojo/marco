defmodule Marco.TweetImporter do
  alias Marco.Repo
  alias Marco.Tweet

  alias Marco.TweetImporter.ApiDatasource

  def import_tweets(user) do
    get_tweets_from(ApiDatasource.Search ,user)
    |> Enum.map(&persist_tweet(&1, user))
  end

  defp get_tweets_from(datasource, user) do
    datasource.get_tweets(user)
  end

  defp persist_tweet(params, user) do
    model = Repo.get_by(Tweet, tweet_id: params.tweet_id) || Ecto.build_assoc(user, :tweets)
    changeset = Tweet.changeset(model, params)
    Repo.insert_or_update(changeset)
  end
end
