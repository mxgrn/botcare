defmodule Botcare.Repo.Migrations.CreateBots do
  use Ecto.Migration

  def change do
    create table(:bots) do
      add :username, :string, null: false
      add :endpoint, :string, null: false
      add :active, :boolean, default: true, null: false
      add :token, :binary, null: false

      timestamps()
    end
  end
end
