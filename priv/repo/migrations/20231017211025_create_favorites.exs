defmodule SpaceGoods.Repo.Migrations.CreateFavorites do
  use Ecto.Migration

  def change do
    create table(:favorites) do
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :product_id, references(:products, on_delete: :nothing), null: false

      timestamps()
    end

    create unique_index(:favorites, [:user_id, :product_id])
  end
end
