defmodule BotcareWeb.WebhookController do
  use BotcareWeb, :controller

  alias Botcare.Bots
  alias Botcare.Bots.Bot

  @default_maintenance_message """
  🔧 The bot is in maintenance mode. Your message has been ignored.
  """

  def maintenance(conn, %{"bot_id" => bot_id} = params) do
    secret = Application.get_env(:botcare, :telegram)[:webhook_secret]

    with [^secret] <- Plug.Conn.get_req_header(conn, "x-telegram-bot-api-secret-token"),
         %Bot{} = bot <- Bots.get(bot_id),
         {:ok, chat_id} <- extract_chat_id(params),
         :ok <-
           TelegramClient.send_message(
             bot,
             chat_id,
             bot.maintenance_message || @default_maintenance_message
           ) do
    end

    text(conn, "OK")
  end

  # Use for debugging
  def active(conn, _params) do
    text(conn, "OK")
  end

  # Extract chat ID to respond to from various bot updates
  defp extract_chat_id(%{"message" => %{"chat" => %{"id" => id}}}), do: {:ok, id}
  defp extract_chat_id(%{"edited_message" => %{"chat" => %{"id" => id}}}), do: {:ok, id}
  defp extract_chat_id(%{"channel_post" => %{"chat" => %{"id" => id}}}), do: {:ok, id}
  defp extract_chat_id(%{"edited_channel_post" => %{"chat" => %{"id" => id}}}), do: {:ok, id}
  defp extract_chat_id(%{"inline_query" => %{"from" => %{"id" => id}}}), do: {:ok, id}
  defp extract_chat_id(%{"chosen_inline_result" => %{"from" => %{"id" => id}}}), do: {:ok, id}
  defp extract_chat_id(%{"pre_checkout_query" => %{"from" => %{"id" => id}}}), do: {:ok, id}
  defp extract_chat_id(%{"my_chat_member" => %{"chat" => %{"id" => id}}}), do: {:ok, id}
  defp extract_chat_id(%{"chat_member" => %{"chat" => %{"id" => id}}}), do: {:ok, id}
  defp extract_chat_id(%{"chat_join_request" => %{"chat" => %{"id" => id}}}), do: {:ok, id}
  defp extract_chat_id(_), do: :error
end
