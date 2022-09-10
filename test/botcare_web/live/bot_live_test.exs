defmodule BotcareWeb.BotLiveTest do
  use BotcareWeb.ConnCase

  import Phoenix.LiveViewTest
  import Botcare.BotsFixtures

  @create_attrs %{
    username: "some name",
    endpoint: "some endpoint",
    token: "some token"
  }

  @update_attrs %{
    username: "some updated username",
    endpoint: "some updated endpoint",
    token: "some updated token"
  }

  @invalid_attrs %{username: nil}

  defp authenticate(%{conn: conn}) do
    conn = conn |> put_req_header("authorization", "Basic " <> Base.encode64("username:password"))
    %{conn: conn}
  end

  defp create_bot(_) do
    bot = bot_fixture()
    %{bot: bot}
  end

  describe "Index" do
    setup [:authenticate, :create_bot]

    test "lists all bots", %{conn: conn, bot: bot} do
      {:ok, _index_live, html} = live(conn, Routes.bot_index_path(conn, :index))

      assert html =~ "Listing Bots"
      assert html =~ bot.username
    end

    test "saves new bot", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.bot_index_path(conn, :index))

      assert index_live |> element("a", "New Bot") |> render_click() =~
               "New Bot"

      assert_patch(index_live, Routes.bot_index_path(conn, :new))

      assert index_live
             |> form("#bot-form", bot: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#bot-form", bot: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.bot_index_path(conn, :index))

      assert html =~ "Bot created successfully"
      assert html =~ "some name"
    end

    test "updates bot in listing", %{conn: conn, bot: bot} do
      {:ok, index_live, _html} = live(conn, Routes.bot_index_path(conn, :index))

      assert index_live |> element("#bot-#{bot.id} a", bot.username) |> render_click() =~
               "Edit Bot"

      assert_patch(index_live, Routes.bot_index_path(conn, :edit, bot))

      assert index_live
             |> form("#bot-form", bot: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#bot-form", bot: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.bot_index_path(conn, :index))

      assert html =~ "Bot updated successfully"
      assert html =~ "some updated username"
    end

    test "deletes bot in listing", %{conn: conn, bot: bot} do
      {:ok, index_live, _html} = live(conn, Routes.bot_index_path(conn, :index))

      assert index_live |> element("#bot-#{bot.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#bot-#{bot.id}")
    end
  end
end
