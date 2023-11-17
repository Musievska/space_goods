defmodule SpaceGoods.Repo.Migrations.RemoveUnwantedFieldsFromCheckouts do
  use Ecto.Migration

  def change do
    alter table(:checkouts) do
      remove :phone_number
      remove :card_number
      remove :expiry_month
      remove :expiry_year
      remove :cvv
    end
  end
end
