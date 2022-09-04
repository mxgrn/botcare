defmodule BotcareWeb.PageController do
  use BotcareWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
