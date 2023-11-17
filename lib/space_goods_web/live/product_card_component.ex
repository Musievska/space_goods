defmodule SpaceGoodsWeb.ProductCardComponent do
  use Phoenix.LiveComponent

  import SpaceGoodsWeb.CoreComponents

  # https://fly.io/phoenix-files/migrating-to-verified-routes/#components-with-routes-in-them
  use Phoenix.VerifiedRoutes,
    endpoint: SpaceGoodsWeb.Endpoint,
    router: SpaceGoodsWeb.Router

  def mount(%{"id" => id, "locale" => locale}, _session, socket) do
    product = Products.get_product!(String.to_integer(id))
    {:ok, assign(socket, product: product, locale: locale)}
  end

  def render(assigns) do
    ~H"""
    <div class="bg-white rounded-lg overflow-hidden shadow-md w-72 h-96">
      <div>
        <.link patch={~p"/#{@locale}/products/#{assigns.product.id}"}>
          <img
            id={"product-image-" <> Integer.to_string(assigns.product.id)}
            loading="lazy"
            class="product-image max-w-full h-48 object-contain mx-auto cursor-pointer"
            src="/images/no_image.jpeg"
            data-src={"/images/#{String.replace(String.downcase(assigns.product.name), " ", "_")}.jpg?v=#{SpaceGoodsWeb.Helpers.asset_version()}"}
            alt={assigns.product.name}
            phx-hook="LoadImage"
          />
        </.link>
        <div class="p-2 text-center justify-center">
          <h2 class="text-xl font-semibold mb-2"><%= assigns.product.name %></h2>
          <p class="font-bold mb-2">
            💲<%= Integer.to_string(Decimal.to_integer(assigns.product.price)) %>
          </p>
          <p class="mb-2 justify-center">⭐ <%= assigns.product.rating %></p>
        </div>
        <div class="flex justify-center mb-4">
          <button
            id={"add-to-cart-" <> Integer.to_string(assigns.product.id)}
            phx-hook="AddToCart"
            phx-click="show-flash"
            data-id={assigns.product.id}
            data-name={assigns.product.name}
            data-price={assigns.product.price}
            value={assigns.product.id}
            class="add-to-cart-button w-12 h-12 mb-2 rounded-full hover:bg-gray-200 focus:outline-none focus:ring-2 focus:ring-black focus:ring-opacity-50 ml-2"
          >
            <.icon
              name="hero-shopping-cart"
              class="ml-1 w-8 h-8 text-red-500 hover:animate-bounce"
            >
            </.icon>
          </button>
          <%= if assigns.on_wishlist_page do %>
            <button
              id={"remove-from-wishlist-" <> Integer.to_string(assigns.product.id)}
              phx-click="remove_from_wishlist"
              phx-value-id={assigns.product.id}
              class="remove-from-wishlist-button w-12 h-12 rounded-full hover:bg-gray-200 focus:outline-none focus:ring-2 focus:ring-black focus:ring-opacity-50"
            >
              <.icon
                name="hero-trash"
                class="ml-1 w-8 h-8 text-red-500 hover:animate-bounce"
              >
              </.icon>
            </button>
          <% else %>
            <button
              id={"add-to-wishlist-" <> Integer.to_string(assigns.product.id)}
              phx-click="add_to_wishlist"
              phx-value-id={assigns.product.id}
              class="add-to-wishlisht-button w-12 h-12 rounded-full hover:bg-gray-200 focus:outline-none focus:ring-2 focus:ring-black focus:ring-opacity-50 ml-2"
            >
              <.icon
                name="hero-heart"
                class="ml-1 w-8 h-8 text-red-500 hover:animate-bounce"
              >
              </.icon>
            </button>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("add_to_cart", %{"id" => id}, socket) do
    user = socket.assigns.current_user
    cart_id = socket.assigns.cart_id

    cart =
      SpaceGoods.Shopping.get_or_create_cart(%{user_id: user && user.id, session_id: cart_id})

    {:ok, _cart_item} = SpaceGoods.Shopping.add_product_to_cart(cart, id)
    socket = put_flash(socket, :info, "Added to cart")
    {:noreply, socket}
  end

  @impl true
  def handle_event("show-flash", _, socket) do
    new_socket = put_flash(socket, :info, "Product is added to cart")
    Process.send_after(self(), :clear_flash, 2000)
    {:noreply, new_socket}
  end

  def handle_event("add_to_wishlist", %{"id" => id}, socket) do
    user = socket.assigns.current_user

    case SpaceGoods.Accounts.add_to_wishlist(user.id, id) do
      {:ok, :added} ->
        new_socket = socket |> put_flash(:info, "product is added to wishlist")
        # send :clear_flash after 2 seconds
        Process.send_after(self(), :clear_flash, 2000)
        {:noreply, new_socket}

      {:error, :already_in_wishlist} ->
        new_socket = socket |> put_flash(:error, "Product is already in wishlist")
        # send :clear_flash after 2 seconds
        Process.send_after(self(), :clear_flash, 2000)
        {:noreply, new_socket}
    end
  end

  @impl true
  def handle_event("remove", %{"product_id" => product_id}, socket) do
    {:noreply, push_event(socket, "remove-product", %{product_id: product_id})}
  end

  @impl true
  def handle_info(:clear_flash, socket) do
    {:noreply, clear_flash(socket)}
  end

  def handle_info({:put_flash, type, message}, _params, socket) do
    {:noreply, put_flash(socket, type, message)}
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
