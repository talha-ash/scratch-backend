defmodule ScratchAppWeb.AuthController do
  use ScratchAppWeb, :controller
  alias ScratchApp.{Accounts, Guardian}
  alias ScratchApp.Accounts.User
  alias ScratchAppWeb.ChangesetJSON


   @access_token_time  2000
   @refresh_token_time  2000

  def login(conn, login_params) do
    %{"email" => email, "password" => password} = login_params

    with {:ok, %User{} = user} <- Accounts.user_auth(%{email: email, password: password}),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user, %{}, ttl: {@access_token_time, :minute}) do
      {:ok, refresh_token, _} =
        Guardian.encode_and_sign(user, %{}, token_type: "refresh", ttl: {@refresh_token_time, :minute})

      conn
      |> put_status(:accepted)
      |> put_resp_cookie("token-cookie", %{refresh_token: refresh_token}, sign: true)
      |> json(%{
        data: %{
          user: %{
            id: user.id,
            username: user.username,
            age: user.age,
            email: user.email
          },
          token: token
        }
      })
    else
      {:error, message} ->
        conn
        |> put_view(ScratchAppWeb.ErrorView)
        |> put_status(404)
        |> json(%{
          data: %{
            error: true,
            message: message
          }
        })
    end
  end

  def register(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user, %{}, ttl: {@access_token_time, :minute}) do
      {:ok, refresh_token, _} =
        Guardian.encode_and_sign(user, %{}, token_type: "refresh", ttl: {@refresh_token_time, :minute})

      conn
      |> put_status(:created)
      |> put_resp_cookie("token-cookie", %{refresh_token: refresh_token}, sign: true)
      |> json(%{
        data: %{
          user: %{
            id: user.id,
            username: user.username,
            age: user.age,
            email: user.email
          },
          token: token
        }
      })
    else
      {:error, changeset} ->
        conn
        |> put_view(ScratchAppWeb.ErrorView)
        |> put_status(401)
        |> json(%{
          data: %{
            error: true,
            message: ChangesetJSON.error(%{changeset: changeset})
          }
        })
    end
  end

  def get_users(conn, _) do
    conn
    |> put_status(200)
    |> json(%{
      data: %{
        users: [
          %{id: 1, username: "user1", age: 25, email: "user1@example.com"},
          %{id: 2, username: "user2", age: 30, email: "user2@example.com"},
          %{id: 3, username: "user3", age: 35, email: "user3@example.com"}
        ]
      }
    })
  end

  def refresh_token(conn, _) do
    token_cookie =
      conn
      |> fetch_cookies(signed: ["token-cookie"])
      |> get_cookies()

    IO.inspect(token_cookie, label: "token_cookie")

    refresh_token =
      Map.get(token_cookie, "token-cookie", %{refresh_token: nil}) |> Map.get(:refresh_token)

    with {:ok, claims} <- Guardian.decode_and_verify(refresh_token, %{"typ" => "refresh"}),
         {:ok, user} <- Guardian.resource_from_claims(claims),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user, %{}, ttl: {@access_token_time, :minute}) do
      {:ok, refresh_token, _} =
        Guardian.encode_and_sign(user, %{}, token_type: "refresh", ttl: {@refresh_token_time, :minute})

      conn
      |> put_status(:created)
      |> put_resp_cookie("token-cookie", %{refresh_token: refresh_token}, sign: true)
      |> json(%{
        data: %{
          user: %{
            id: user.id,
            username: user.username,
            age: user.age,
            email: user.email
          },
          token: token
        }
      })
    else
      {:error, _} ->
        conn
        |> put_status(401)
        |> json(%{
          data: %{
            error: true,
            message: "refresh token Expired"
          }
        })
    end
  end
end
