defmodule SpaceGoods.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :name, :string
    field :description, :string
    field :category, :string
    field :price, :decimal
    field :rating, :float
    field :image_url, :string

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :price, :rating, :category, :image_url])
    |> validate_required([:name, :description, :price, :rating, :category, :image_url])
  end
end
