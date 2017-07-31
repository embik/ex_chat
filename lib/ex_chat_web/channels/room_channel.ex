defmodule ExChatWeb.RoomChannel do
  use ExChatWeb, :channel

  def join("room:lobby", payload, socket) do
    {:ok, socket}
  end

  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "Unauthorized"}}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    time = DateTime.utc_now |> DateTime.to_iso8601
    broadcast! socket, "new_msg", %{body: body, username: socket.assigns.username, time: time}
    {:noreply, socket}
  end

  def handle_out("new_msg", payload, socket) do
    push socket, "new_msg", payload
    {:noreply, socket}
  end
end
