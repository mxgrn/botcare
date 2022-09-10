defmodule TelegramClient do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://api.telegram.org"
  plug Tesla.Middleware.JSON

  def set_webhook(bot, url) do
    get("/bot#{bot.token}/setWebhook?url=#{url}")
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
