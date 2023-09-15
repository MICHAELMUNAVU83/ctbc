defmodule CtbcWeb.SystemUserLive.Index do
  use CtbcWeb, :dashboard_live_view

  alias Ctbc.Users

  @impl true
  def mount(_params, session, socket) do
    current_user = Users.get_user_by_session_token(session["user_token"])

    users = Users.list_users()

    {:ok,
     socket
     |> assign(:url, "/system_users")
     |> assign(:users, users)
     |> assign(:current_user, current_user)}
  end

  def handle_event("verify", %{"id" => id}, socket) do
    user = Users.get_user!(id)

    {:ok, user} = Users.update_user(user, %{role: "verified"})
    IO.inspect(user)

    users = Users.list_users()

    {:noreply,
     socket
     |> assign(:users, users)
     |> put_flash(:info, "User verified")}
  end

  def handle_event("unverify", %{"id" => id}, socket) do
    user = Users.get_user!(id)

    {:ok, user} = Users.update_user(user, %{role: "unverified"})
    IO.inspect(user)

    users = Users.list_users()

    {:noreply,
     socket
     |> assign(:users, users)
     |> put_flash(:info, "User unverified")}
  end
end
