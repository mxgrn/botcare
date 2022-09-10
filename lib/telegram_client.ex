defmodule TelegramClient do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://api.telegram.org"
  plug Tesla.Middleware.JSON

  def set_webhook(bot, url) do
    webhook_secret = Application.get_env(:botcare, :telegram)[:webhook_secret]

    "/bot#{bot.token}/setWebhook"
    |> post(%{url: url, secret_token: webhook_secret})
    |> parse_response()
  end

  def send_message(bot, chat_id, message) do
    "/bot#{bot.token}/sendMessage"
    |> post(%{chat_id: chat_id, text: message})
    |> parse_response()
  end

  # Poor-man's Tesla error handling
  defp parse_response({:ok, %Tesla.Env{body: %{"ok" => true}}}) do
    :ok
  end

  defp parse_response(_) do
    {:error, "Calling Telegram API failed"}
  end
end
