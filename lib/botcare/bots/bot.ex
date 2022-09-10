defmodule Botcare.Bots.Bot do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bots" do
    field :username, :string
    field :endpoint, :string
    field :token, Botcare.Encrypted.Binary
    field :active, :boolean, default: true

    timestamps()
  end

  @doc false
  def changeset(bot, attrs) do
    bot
    |> cast(attrs, [:username, :endpoint, :token, :active])
    |> validate_required([:username, :endpoint, :token, :active])
  end
end
