defmodule SpaceGoods.Repo.Migrations.AddDeliveryDateToCheckouts do
  use Ecto.Migration

  def change do
    alter table(:checkouts) do
      add :delivery_date, :utc_datetime
    end
  end
end
