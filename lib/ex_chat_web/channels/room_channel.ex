defmodule ExChatWeb.RoomChannel do
  use ExChatWeb, :channel

  alias ExChatWeb.Presence
  alias ExChat.Chats
  alias ExChat.Chats.Room
  require Logger

  intercept ["new_msg"]

  def join("room:" <> room_name, _payload, socket) do
    user = Guardian.Phoenix.Socket.current_resource(socket)
    case Chats.get_room_by_name(room_name) do
      %Room{} = room ->
        send(self(), {:after_join, room.name, user})
        {:ok, assign(socket, :user, user)}
      _ ->
        {:error, %{"reason" => "room does not exist"}}
    end
  end

  def handle_info({:after_join, room, user}, socket) do
    Presence.track(socket, user.name, %{ online_at: :os.system_time(:milli_seconds) })
    push(socket, "presence_state", Presence.list(socket))

    msgs = ExChat.MsgDb.get_latest(room)
    for msg <- msgs, do: push(socket, "new_msg", msg)

    {:noreply, socket}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    time = DateTime.utc_now |> DateTime.to_unix
    user = socket.assigns.user

    case socket.topic do
      "room:" <> room ->
        ExChat.MsgDb.put(body, user.name, time, room)
        broadcast!(socket, "new_msg", %{body: body, username: user.name, time: time})
        {:noreply, socket}
      _ ->
        :error
    end
  end

  def handle_out("new_msg", payload, socket) do
    push socket, "new_msg", payload
    {:noreply, socket}
  end
end
