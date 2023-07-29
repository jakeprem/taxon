defmodule TaxonWeb.UserAuth.Fast do
  import Plug.Conn

  alias TaxonWeb.UserAuth

  @fast_token_cookie "_taxon_web_user_fast_token"
  @fast_token_namespace "fast_token"
  # Allow the fast token for 1 day, i.e. we'll recheck the database once per day
  @fast_token_max_age 60 * 60 * 24

  @doc """
  Adds an auth token to the session and a cookie.

  This will be used to check user auth without a database hit.
  """
  def add_fast_token(conn, user) do
    token = generate_fast_token(conn, user)

    conn
    |> put_session(:fast_token, token)
    |> put_resp_cookie(@fast_token_cookie, token)
  end

  @doc """
  Attempt to authenticate a user using a stateless signed token.

  If the token is expired, falls back to the normal user auth.

  Any other scenario will be redirected to login.
  """
  def fast_user_check(conn, _opts) do
    with {:found, token, conn} <- find_token(conn),
         {:ok, user_id} <- verify_fast_token(conn, token) do
      assign(conn, :fast_user_id, user_id)
    else
      {:not_found, nil, conn} ->
        UserAuth.redirect_to_require_login(conn)

      {:error, :expired} ->
        case UserAuth.fetch_current_user(conn, []) do
          nil ->
            UserAuth.redirect_to_require_login(conn)

          user ->
            add_fast_token(conn, user)
        end

      {:error, _} ->
        UserAuth.redirect_to_require_login(conn)
    end
  end

  defp find_token(conn) do
    if token = get_session(conn, :fast_token) do
      {:found, token, conn}
    else
      conn = fetch_cookies(conn, signed: [@fast_token_cookie])

      if token = conn.cookies[@fast_token_cookie] do
        {:found, token, put_session(conn, :fast_token, token)}
      else
        {:not_found, nil, conn}
      end
    end
  end

  defp generate_fast_token(conn, user) do
    Phoenix.Token.sign(conn, @fast_token_namespace, user.id)
  end

  defp verify_fast_token(conn, token) do
    Phoenix.Token.verify(conn, @fast_token_namespace, token, max_age: @fast_token_max_age)
  end
end
