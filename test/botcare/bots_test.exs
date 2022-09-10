defmodule Botcare.BotsTest do
  use Botcare.DataCase

  alias Botcare.Bots

  describe "bots" do
    alias Botcare.Bots.Bot

    import Botcare.BotsFixtures

    @invalid_attrs %{username: nil, token: nil}

    test "list_bots/0 returns all bots" do
      bot = bot_fixture()
      assert Bots.list_bots() == [bot]
    end

    test "get_bot!/1 returns the bot with given id" do
      bot = bot_fixture()
      assert Bots.get_bot!(bot.id) == bot
    end

    test "create_bot/1 with valid data creates a bot" do
      valid_attrs = %{
        username: "some username",
        active: false,
        endpoint: "some endpoint",
        token: "some token"
      }

      assert {:ok, %Bot{} = bot} = Bots.create_bot(valid_attrs)
      assert bot.username == "some username"
      assert bot.active == false
      assert bot.endpoint == "some endpoint"
      assert bot.token == "some token"
    end

    test "create_bot/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bots.create_bot(@invalid_attrs)
    end

    test "update_bot/2 with valid data updates the bot" do
      bot = bot_fixture()

      update_attrs = %{
        username: "some updated username",
        active: false,
        token: "some updated token"
      }

      assert {:ok, %Bot{} = bot} = Bots.update_bot(bot, update_attrs)
      assert bot.username == "some updated username"
      assert bot.active == false
      assert bot.token == "some updated token"
    end

    test "update_bot/2 with invalid data returns error changeset" do
      bot = bot_fixture()
      assert {:error, %Ecto.Changeset{}} = Bots.update_bot(bot, @invalid_attrs)
      assert bot == Bots.get_bot!(bot.id)
    end

    test "delete_bot/1 deletes the bot" do
      bot = bot_fixture()
      assert {:ok, %Bot{}} = Bots.delete_bot(bot)
      assert_raise Ecto.NoResultsError, fn -> Bots.get_bot!(bot.id) end
    end

    test "change_bot/1 returns a bot changeset" do
      bot = bot_fixture()
      assert %Ecto.Changeset{} = Bots.change_bot(bot)
    end
  end
end
