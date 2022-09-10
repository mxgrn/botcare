defmodule BotcareWeb.WebhookController do
  use BotcareWeb, :controller

  def maintenance(conn, _params) do
    text(conn, "OK")
  end

  # Use for debugging
  def active(conn, _params) do
    text(conn, "OK")
  end
end
