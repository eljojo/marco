defmodule Marco.Tweet do
  use Marco.Web, :model

  schema "tweets" do
    field :tweet_id, :integer
    field :twitter_user_id, :integer
    field :tweeted_at, Ecto.DateTime
    field :favorite_count, :integer
    field :retweet_count, :integer
    field :lang, :string
    field :in_reply_to_status_id, :integer
    field :text, :string
    belongs_to :user, Marco.User

    timestamps(inserted_at: :fetched_at, updated_at: false)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:tweet_id, :twitter_user_id, :tweeted_at, :favorite_count, :retweet_count, :lang, :in_reply_to_status_id, :text])
    |> validate_required([:user_id, :tweet_id, :twitter_user_id, :tweeted_at, :text])
  end
end
