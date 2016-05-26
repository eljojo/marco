defmodule Marco.User do
  use Marco.Web, :model

  schema "users" do
    field :name, :string
    field :twitter_handle, :string
    field :twitter_id, :integer
    field :twitter_access_token, :string
    field :twitter_access_secret, :string
    field :twitter_avatar, :string

    timestamps

    has_many :tweets, Marco.Tweet
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :twitter_handle, :twitter_id, :twitter_access_token, :twitter_access_secret, :twitter_avatar])
    |> validate_required([:name, :twitter_handle, :twitter_id, :twitter_access_token, :twitter_access_secret, :twitter_avatar])
  end
end
