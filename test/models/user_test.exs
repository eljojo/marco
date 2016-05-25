defmodule Marco.UserTest do
  use Marco.ModelCase

  alias Marco.User

  @valid_attrs %{name: "some content", twitter_access_secret: "some content", twitter_access_token: "some content", twitter_handle: "some content", twitter_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
