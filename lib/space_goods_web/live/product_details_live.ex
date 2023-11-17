defmodule SpaceGoodsWeb.ProductDetailsLive do
  use SpaceGoodsWeb, :live_view

  alias SpaceGoods.Products

  on_mount {SpaceGoodsWeb.UserAuth, :mount_current_user}

  def mount(%{"id" => id, "locale" => locale}, _session, socket) do
    product = Products.get_product!(String.to_integer(id))
    {:ok, assign(socket, product: product, locale: locale)}
  end

  def render(assigns) do

    ~H"""
    <%!-- <h1>Product Details <%= assigns.locale%></h1> --%>
    <section class="text-gray-700 body-font overflow-hidden bg-white">
      <div class="container px-5 py-24 mx-auto">
        <!-- Flex container with wrap to handle different screen sizes -->
        <div class="flex flex-wrap -mx-4">
          <!-- Image container with responsive width -->
          <div class="lg:w-1/2 w-full px-4">
            <img
              alt={assigns.product.name}
              id={"product-image-" <> Integer.to_string(assigns.product.id)}
              loading="lazy"
              class="w-full object-cover object-center rounded border border-gray-200 h-auto max-h-76 object-fit"
              data-src={"/images/#{String.replace(String.downcase(assigns.product.name), " ", "_")}.jpg?v=#{SpaceGoodsWeb.Helpers.asset_version()}"}
              onerror="this.onerror=null; this.src='/images/no_image.jpeg'"
              phx-hook="LoadImage"
            />
          </div>
          <!-- Details container with responsive width and padding -->
          <div class="lg:w-1/2 w-full lg:pl-10 lg:py-6 mt-6 lg:mt-0 px-4">
            <h1 class="text-gray-900 text-3xl title-font font-medium mb-1 text-center">
              <%= assigns.product.name %>
            </h1>
            <p class="leading-relaxed mb-4 text-center">
              <%= assigns.product.description %>
            </p>
            <!-- Flex container for price and rating with wrap and responsive spacing -->
            <div class="flex flex-wrap items-center justify-center mb-5">
              <div class="w-full lg:w-auto pr-4 mb-4 lg:mb-0 text-center">
                <span class="title-font font-medium text-2xl text-gray-900">
                  💲<%= Integer.to_string(Decimal.to_integer(assigns.product.price)) %>
                </span>
              </div>
              <div class="w-full lg:w-auto text-center">
                <span class="title-font font-medium text-2xl text-gray-900">
                  ⭐ <%= assigns.product.rating %>
                </span>
              </div>
            </div>
            <!-- Flex container for buttons with responsive margin -->
            <div class="flex items-center justify-center">
              <!-- This ensures vertical alignment to center -->
              <button
                id={"add-to-cart-" <> Integer.to_string(assigns.product.id)}
                phx-hook="AddToCart"
                phx-click="show-flash"
                data-id={assigns.product.id}
                data-name={assigns.product.name}
                data-price={assigns.product.price}
                value={assigns.product.id}
                class="add-to-cart-button w-12 h-12 rounded-full hover:bg-gray-200 focus:outline-none focus:ring-2 focus:ring-black focus:ring-opacity-50"
              >
                <.icon
                  name="hero-shopping-cart"
                  class="ml-1 w-8 h-8 text-red-500 hover:animate-bounce"
                >
                </.icon>
              </button>
              <button
                id={"add-to-wishlist-" <> Integer.to_string(assigns.product.id)}
                phx-click="add_to_wishlist"
                phx-value-id={assigns.product.id}
                class="add-to-wishlist-button w-12 h-12 rounded-full hover:bg-gray-200 focus:outline-none focus:ring-2 focus:ring-black focus:ring-opacity-50 ml-2"
              >
                <.icon
                  name="hero-heart"
                  class="ml-1 w-8 h-8 text-red-500 hover:animate-bounce"
                >
                </.icon>
              </button>
            </div>
          </div>
        </div>
      </div>
      <.link patch={~p"/#{@locale}/upload-photos"}>
      <.promo class="pb-4"> <!-- Added padding-bottom -->
          Save 25% on your next purchase!
          <:legal>
            Learn more...
          </:legal>
        </.promo>
      </.link>
    </section>
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
  def handle_info(:clear_flash, socket) do
    {:noreply, clear_flash(socket)}
  end

  def handle_info({:put_flash, type, message}, _params, socket) do
    {:noreply, put_flash(socket, type, message)}
  end
end
