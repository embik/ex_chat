defmodule ExChatWeb.RoomChannel do
  use ExChatWeb, :channel

  alias ExChatWeb.Presence
  require Logger

  intercept ["new_msg"]

  def join("room:lobby", payload, socket) do
    user = Guardian.Phoenix.Socket.current_resource(socket)
    send(self(), {:after_join, "lobby", user})

    {:ok, assign(socket, :user, user)}
  end

  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "Unauthorized"}}
  end

  def handle_info({:after_join, room, user}, socket) do
    Presence.track(socket, user.name, %{ online_at: :os.system_time(:milli_seconds) })
    push(socket, "presence_state", Presence.list(socket))

    msgs = ExChat.MsgDb.get_latest(room)
    for msg <- msgs, do: push(socket, "new_msg", msg)

    {:noreply, socket}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    time = DateTime.utc_now |> DateTime.to_iso8601
    user = socket.assigns.user

    ExChat.MsgDb.put(body, user.name, time, "lobby")
    broadcast!(socket, "new_msg", %{body: body, username: user.name, time: time})

    {:noreply, socket}
  end

  def handle_out("new_msg", payload, socket) do
    push socket, "new_msg", payload
    {:noreply, socket}
  end
end
