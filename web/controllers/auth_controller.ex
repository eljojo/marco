defmodule Marco.AuthController do
  use Marco.Web, :controller
  plug Ueberauth

  alias Ueberauth.Strategy.Helpers
  alias Marco.User

  def request(conn, _params) do
    render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case find_or_create_user(user_params_from_auth(auth)) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> put_session(:current_user, user)
        |> redirect(to: "/")
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end

  defp find_or_create_user(params) do
    user = Repo.get_by(User, twitter_id: params.twitter_id) || %User{}
    changeset = User.changeset(user, params)
    Repo.insert_or_update(changeset)
  end

  defp user_params_from_auth(%Ueberauth.Auth{} = auth) do
    %{
      name: auth.info.name,
      twitter_id: String.to_integer(auth.uid),
      twitter_handle: auth.info.nickname,
      twitter_access_token: to_string(auth.credentials.secret),
      twitter_access_secret: to_string(auth.credentials.token),
      twitter_avatar: auth.info.image
    }
  end
end
