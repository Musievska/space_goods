defmodule SpaceGoods.Repo.Migrations.CreateCheckouts do
  use Ecto.Migration

  def change do
    create table(:checkouts) do
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :city, :string
      add :address, :string
      add :zip, :integer
      add :phone_number, :integer
      add :card_number, :integer
      add :expiry_month, :integer
      add :expiry_year, :integer
      add :cvv, :integer
      add :shipping_same_as_billing, :boolean
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:checkouts, [:user_id])
  end
end
