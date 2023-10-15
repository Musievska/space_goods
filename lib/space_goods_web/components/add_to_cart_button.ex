defmodule SpaceGoodsWeb.AddToCartButton do
  use Phoenix.Component

  @doc """
  Renders an "Add to Cart" button.
  """
  attr :product_id, :integer, required: true
  slot :inner_block, default: "Add to Cart"

  def button(assigns) do
    product_id = Integer.to_string(@product_id)

    ~H"""
    <button
      class="add-to-cart-button"
      data-product-id="#{product_id}"
      phx-click="add_to_cart"
      phx-value-product-id="#{product_id}"
    >
      <%= render_slot(@inner_block) %>
    </button>
    """
  end
end
