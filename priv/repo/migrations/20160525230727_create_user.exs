defmodule Marco.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :twitter_handle, :string
      add :twitter_id, :bigint
      add :twitter_access_token, :string
      add :twitter_access_secret, :string

      timestamps
    end

  end
end
