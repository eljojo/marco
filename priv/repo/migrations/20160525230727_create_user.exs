defmodule Marco.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :twitter_handle, :string, null: false
      add :twitter_id, :bigint, null: false
      add :twitter_access_token, :string, null: false
      add :twitter_access_secret, :string, null: false
      add :twitter_avatar, :string

      timestamps
    end

    create index(:users, [:twitter_id], unique: true)
  end
end
