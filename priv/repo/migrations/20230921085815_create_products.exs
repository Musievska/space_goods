defmodule SpaceGoods.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :price, :decimal
      add :description, :text
      add :rating, :float
      add :reviews_count, :integer, default: 0
      add :total_rating, :integer, default: 0
      add :category, :string
      add :image_url, :string
      add :sku, :string
      add :stock_quantity, :integer
      add :featured, :boolean, default: false
      add :tags, {:array, :string}

      timestamps()
    end

    create unique_index(:products, [:sku])
  end
end
