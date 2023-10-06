defmodule SpaceGoods.Shopping.Cart do
  use Ecto.Schema
  import Ecto.Changeset

  schema "carts" do
    belongs_to :user, SpaceGoods.Accounts.User
    has_many :cart_items, SpaceGoods.Shopping.CartItem
    timestamps()
  end

  @doc false
  def changeset(cart, attrs) do
    cart
    |> cast(attrs, [:user_id])
    |> validate_required([:user_id])
    |> assoc_constraint(:user)
  end
end
