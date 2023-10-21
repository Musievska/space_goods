defmodule SpaceGoods.Shopping do
  alias SpaceGoods.Repo
  alias SpaceGoods.Shopping.{Cart, CartItem}
  alias SpaceGoods.Products.Product
  import Ecto.Query

  def get_or_create_cart(%{user_id: user_id, session_id: session_id}) do
    query =
      from(c in Cart,
        where: c.user_id == ^user_id or c.session_id == ^session_id,
        preload: :cart_items
      )

    case Repo.one(query) do
      nil ->
        %Cart{user_id: user_id, session_id: session_id}
        |> Cart.changeset(%{})
        |> Repo.insert!()

      cart ->
        cart
    end
  end

  def add_product_to_cart(cart, product_id) do
    case Repo.get_by(CartItem, cart_id: cart.id, product_id: product_id) do
      nil ->
        %CartItem{cart_id: cart.id, product_id: product_id, quantity: 1}
        |> CartItem.changeset(%{})
        |> Repo.insert()

      cart_item ->
        changeset = CartItem.changeset(cart_item, %{quantity: cart_item.quantity + 1})
        Repo.update(changeset)
    end
  end

  def remove_product_from_cart(cart_item_id) do
    cart_item = Repo.get!(CartItem, cart_item_id)
    Repo.delete(cart_item)
  end

  def update_cart_item_quantity(cart_item_id, new_quantity) when new_quantity > 0 do
    cart_item = Repo.get!(CartItem, cart_item_id)
    changeset = CartItem.changeset(cart_item, %{quantity: new_quantity})
    Repo.update(changeset)
  end

  def get_cart_count_for_user(user_id) do
    case get_or_create_cart(user_id) do
      %Cart{id: cart_id} ->
        Repo.aggregate(CartItem, :count, :id, cart_id: cart_id)

      _ ->
        0
    end
  end

  def get_cart_items_for_user(user_id) do
    case get_or_create_cart(user_id) do
      %Cart{id: cart_id} ->
        CartItem
        |> where(cart_id: ^cart_id)
        |> Repo.all(preload: :product)

      _ ->
        []
    end
  end

  # Clear all items from a user's cart
  def clear_cart(user_id) do
    case get_or_create_cart(user_id) do
      %Cart{id: cart_id} ->
        CartItem
        |> where(cart_id: ^cart_id)
        |> Repo.delete_all()

      _ ->
        {:error, "Cart not found"}
    end
  end
end
