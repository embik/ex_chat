defmodule ExChat.MsgDb do
  import Tirexs.Search
  import Tirexs.HTTP

  @log_length 20

  def get_latest(channel) do
    query = search [index: "ex_chat"] do
      size @log_length
      sort do [%{"time" => %{"order" => "desc"}}] end
      query do match "channel", channel end
    end
    case Tirexs.Query.create_resource(query) do
      {:ok, 200, %{hits: %{ hits: results }}} ->
        results |> extract_msg |> Enum.reverse
      _ -> []
    end
  end

  def put(body, username, time, channel) do
    post("/ex_chat/messages/", [body: body, username: username, time: time, channel: channel])
  end

  defp extract_msg([]), do: []
  defp extract_msg([head | tail]) do
    [head._source] ++ extract_msg(tail)
  end
end
