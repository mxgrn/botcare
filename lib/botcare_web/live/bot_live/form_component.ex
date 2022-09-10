defmodule BotcareWeb.BotLive.FormComponent do
  use BotcareWeb, :live_component

  alias Botcare.Bots

  @impl true
  def update(%{bot: bot} = assigns, socket) do
    changeset = Bots.change_bot(bot)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"bot" => bot_params}, socket) do
    changeset =
      socket.assigns.bot
      |> Bots.change_bot(bot_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"bot" => bot_params}, socket) do
    save_bot(socket, socket.assigns.action, bot_params)
  end

  defp save_bot(socket, :edit, bot_params) do
    case Bots.update_bot(socket.assigns.bot, bot_params) do
      {:ok, _bot} ->
        {:noreply,
         socket
         |> put_flash(:info, "Bot updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_bot(socket, :new, bot_params) do
    case Bots.create_bot(bot_params) do
      {:ok, _bot} ->
        {:noreply,
         socket
         |> put_flash(:info, "Bot created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
