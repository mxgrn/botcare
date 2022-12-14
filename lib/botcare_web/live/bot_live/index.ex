defmodule BotcareWeb.BotLive.Index do
  use BotcareWeb, :live_view

  alias Botcare.Bots
  alias Botcare.Bots.Bot

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :bots, list_bots())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Bot")
    |> assign(:bot, Bots.get_bot!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Bot")
    |> assign(:bot, %Bot{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Bots")
    |> assign(:bot, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    bot = Bots.get_bot!(id)
    {:ok, _} = Bots.delete_bot(bot)

    {:noreply, assign(socket, :bots, list_bots())}
  end

  def handle_event("toggle", %{"id" => id}, socket) do
    bot = Bots.get_bot!(id)

    new_webhook_url =
      case bot do
        %{active: true} -> maintenance_url(socket, id)
        %{active: false} -> bot.endpoint
      end

    TelegramClient.set_webhook(bot, new_webhook_url)
    |> case do
      :ok ->
        Bots.toggle!(bot)
        {:noreply, assign(socket, :bots, list_bots())}

      _ ->
        {:noreply,
         socket
         |> put_flash(:error, "Could not update webhook URL")}
    end
  end

  defp list_bots do
    Bots.list_bots()
  end

  defp maintenance_url(socket, id) do
    Routes.webhook_url(socket, :maintenance, id)
    # BotcareWeb.Endpoint.url() <> "/maintenance"
  end
end
