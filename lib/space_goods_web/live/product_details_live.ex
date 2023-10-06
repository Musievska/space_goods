defmodule SpaceGoodsWeb.ProductDetailsLive do
  use SpaceGoodsWeb, :live_view

  alias SpaceGoods.Products

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    product = Products.get_product!(id)
    {suggested_products, _count} = Products.list_products(%{category: product.category}, 1, 4)
    {:ok, assign(socket, product: product, suggested_products: suggested_products)}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div class="container mx-auto p-4">
      <div class="bg-white rounded-lg overflow-hidden shadow-md border-4 border-gray-300 max-w-2xl mx-auto">
        <img loading="lazy" class="w-full h-64 object-cover"
        src="<%= @product.image_url %>?v=<%= SpaceGoodsWeb.Helpers.asset_version() %>"
        alt="<%= @product.name %>"
        onerror="this.onerror=null; this.src='/images/no_image.jpeg?v=<%= SpaceGoodsWeb.Helpers.asset_version() %>';">
        <div class="p-6">
          <h2 class="text-2xl font-semibold mb-2"><%= @product.name %></h2>
          <p class="font-bold mb-2">Price: <%= @product.price %></p>
          <p class="mb-2">Rating: <%= @product.rating %></p>
          <button phx-click="add_to_cart" phx-value-id="<%= @product.id %>" class="bg-red-500 text-black rounded hover:bg-red-700">Add to Cart</button>
        </div>
      </div>

      <!-- Suggested Products -->
        <h2 class="text-2xl font-semibold mt-8 mb-4 text-red-500">Suggested Products</h2>
        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
        <%= for suggested_product <- @suggested_products do %>
          <div class="bg-white rounded-lg overflow-hidden shadow-md border-4 border-gray-300">
            <img loading="lazy" class="w-full h-64 object-cover"
            src="<%= suggested_product.image_url %>?v=<%= SpaceGoodsWeb.Helpers.asset_version() %>"
            alt="<%= suggested_product.name %>"
            onerror="this.onerror=null; this.src='/images/no_image.jpeg?v=<%= SpaceGoodsWeb.Helpers.asset_version() %>';">
            <div class="p-6">
              <h2 class="text-xl font-semibold mb-2"><%= suggested_product.name %></h2>
              <p class="font-bold mb-2">Price: <%= suggested_product.price %></p>
              <p class="mb-2">Rating: <%= suggested_product.rating %></p>
              <button phx-click="add_to_cart" phx-value-id="<%= suggested_product.id %>" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-700">Add to Cart</button>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
