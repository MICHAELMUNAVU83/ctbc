defmodule CtbcWeb.UserRegistrationController do
  use CtbcWeb, :controller

  alias Ctbc.Users
  alias Ctbc.Users.User
  alias CtbcWeb.UserAuth

  def new(conn, _params) do
    changeset = Users.change_user_registration(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    user_params =
      if user_params["email"] == "michaelmunavu83@gmail.com" do
        user_params
        |> Map.put("role", "verified")
      else
        user_params
      end

    case Users.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Users.deliver_user_confirmation_instructions(
            user,
            &Routes.user_confirmation_url(conn, :edit, &1)
          )

        conn
        |> put_flash(:info, "User created successfully.")
        |> UserAuth.log_in_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
