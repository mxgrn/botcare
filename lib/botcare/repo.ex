defmodule Botcare.Repo do
  use Ecto.Repo,
    otp_app: :botcare,
    adapter: Ecto.Adapters.Postgres
end
