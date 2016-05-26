defmodule Marco.Repo.Migrations.CreateTweet do
  use Ecto.Migration

  def change do
    create table(:tweets) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :tweet_id, :bigint, null: false
      add :twitter_user_id, :bigint, null: false
      add :tweeted_at, :datetime, null: false
      add :fetched_at, :datetime, null: false
      add :favorite_count, :integer, default: 0
      add :retweet_count, :integer, default: 0
      add :lang, :string, size: 10
      add :in_reply_to_status_id, :bigint
      add :text, :text, null: false
    end

    create index(:tweets, [:user_id, :tweet_id])
    create index(:tweets, [:tweet_id], unique: true)
  end
end
