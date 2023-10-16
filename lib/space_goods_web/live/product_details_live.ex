defmodule SpaceGoodsWeb.ProductDetailsLive do
  use SpaceGoodsWeb, :live_view

  alias SpaceGoods.Products

  on_mount {SpaceGoodsWeb.UserAuth, :mount_current_user}

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    product = Products.get_product!(String.to_integer(id))
    {:ok, assign(socket, product: product)}
  end

  # @impl true
  # def handle_event("add_to_cart", %{"id" => id}, socket) do
  #   {:noreply,
  #    push_patch(socket, to: "/cart", flash: %{info: "Added to cart"})}
  # end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-3xl">
      <div class="flex justify-between mb-4">
        <div class="flex-1">
          <h1 class="text-3xl font-bold mb-2"><%= @product.name %></h1>
          <p class="text-gray-600"><%= @product.price %></p>
        </div>
        <div class="flex-1">
          <img
            id={"@product-image-" <> Integer.to_string(@product.id)}
            loading="lazy"
            class="product-image w-full h-64 object-cover"
            src="/images/no_image.jpeg"
            data-src={"/images/#{String.replace(String.downcase(@product.name), " ", "_")}.jpg?v=#{SpaceGoodsWeb.Helpers.asset_version()}"}
            alt={@product.name}
            phx-hook="LoadImage"
          />
        </div>
      </div>
      <div class="flex justify-between">
        <div class="flex-1">
          <p class="text-2xl font-bold mb-2"><%= @product.price %></p>
          <p class="mb-2">Rating: <%= @product.rating %></p>
        </div>
        <%!-- <div class="flex-1">
          <%= live_component(@socket, SpaceGoodsWeb.AddToCartButton,
            product_id: @product.id,
            inner_block: "Add to Cart"
          ) %>
        </div> --%>
      </div>
    </div>
    """
  end
end
