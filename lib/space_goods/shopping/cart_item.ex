defmodule SpaceGoods.Shopping.CartItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cart_items" do
    belongs_to :cart, SpaceGoods.Shopping.Cart
    belongs_to :product, SpaceGoods.Products.Product
    field :quantity, :integer
    timestamps()
  end

  @doc false
  def changeset(cart_item, attrs) do
    cart_item
    |> cast(attrs, [:cart_id, :product_id, :quantity])
    |> validate_required([:cart_id, :product_id, :quantity])
    |> assoc_constraint(:cart)
    |> assoc_constraint(:product)
  end
end
