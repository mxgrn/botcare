defmodule Botcare.BotsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Botcare.Bots` context.
  """

  @doc """
  Generate a bot.
  """
  def bot_fixture(attrs \\ %{}) do
    {:ok, bot} =
      attrs
      |> Enum.into(%{
        username: "some username",
        endpoint: "some endpoint",
        active: true,
        token: "some token"
      })
      |> Botcare.Bots.create_bot()

    bot
  end
end
