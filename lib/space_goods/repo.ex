defmodule SpaceGoods.Repo do
  use Ecto.Repo,
    otp_app: :space_goods,
    adapter: Ecto.Adapters.Postgres
    use Paginator
end
