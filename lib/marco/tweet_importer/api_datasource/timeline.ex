defmodule Marco.TweetImporter.ApiDatasource.Timeline do
  require Logger

  def query_api(user, opts \\ %{}) do
    default_opts = %{count: 200}
    options = Map.merge(default_opts, Map.new(opts))
    Logger.debug "fetching tweets through timeline api: " <> inspect(options)
    try do
      tweets = ExTwitter.user_timeline(Map.to_list(options))
      {:ok, tweets}
    rescue
      # https://github.com/parroty/extwitter/blob/94bcd32ccdbb1985e0e1af71c71b6dd116822c45/lib/extwitter/api/base.ex#L29
      e in ExTwitter.ConnectionError ->
        Logger.error "error getting tweets" <> inspect(e)
        {:error, e}
    end
  end
end
