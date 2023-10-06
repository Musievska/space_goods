defmodule SpaceGoods.Shopping do
  alias SpaceGoods.Repo
  alias SpaceGoods.Shopping.Cart
  alias SpaceGoods.Shopping.CartItem

  def get_or_create_cart(user_id) do
    Repo.get_by(Cart, user_id: user_id) ||
      %Cart{user_id: user_id}
      |> Cart.changeset(%{})
      |> Repo.insert!()
  end

  def add_product_to_cart(cart, product_id) do
    %CartItem{cart_id: cart.id, product_id: product_id, quantity: 1}
    |> CartItem.changeset(%{})
    |> Repo.insert()
  end

  def get_cart_count_for_user(user_id) do
    case get_or_create_cart(user_id) do
      %Cart{id: cart_id} ->
        CartItem
        |> Repo.get_by(cart_id: cart_id)
        |> Enum.count()

      _ ->
        0
    end
  end
end
