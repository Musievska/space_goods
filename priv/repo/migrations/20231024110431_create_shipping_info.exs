defmodule SpaceGoods.Repo.Migrations.CreateShippingInfo do
  use Ecto.Migration

  def change do
    create table(:shipping_info) do
      add :address, :string
      add :city, :string
      add :state, :string
      add :zip, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:shipping_info, [:user_id])
  end
end
