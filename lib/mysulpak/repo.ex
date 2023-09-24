defmodule Mysulpak.Repo do
  use Ecto.Repo,
    otp_app: :mysulpak,
    adapter: Ecto.Adapters.Postgres
end
