defmodule SpaceGoodsWeb.CartIconComponent do
  use Phoenix.Component

  def cart_icon(assigns) do
    ~H"""
    <div class="cart-icon">
      <a href="/cart">
        <img src="priv/static/icons/add_cart.png" alt="Cart" />
        <span class="cart-count">{@cart_count}</span>
      </a>
    </div>
    """
  end
end
