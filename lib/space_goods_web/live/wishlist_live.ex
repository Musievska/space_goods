defmodule SpaceGoodsWeb.WishlistLive do
  use SpaceGoodsWeb, :live_view

  import SpaceGoodsWeb.CustomComponents

  use Phoenix.VerifiedRoutes,
    endpoint: SpaceGoodsWeb.Endpoint,
    router: SpaceGoodsWeb.Router

  on_mount {SpaceGoodsWeb.UserAuth, :mount_current_user}

  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    wishlist = SpaceGoods.Accounts.list_wishlist(user.id)
    {:ok, assign(socket, wishlist: wishlist)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.link patch={~p"/#{@locale}/upload-photos"}>
        <.promo>
          Save 25% on your next purchase!
          <:legal>
            Learn more...
          </:legal>
        </.promo>
      </.link>
      <!-- Wishlist Page Content -->
      <div class="wishlist grid grid-cols-1 md:grid-cols-3 sm:grid-cols-2 gap-10 justify-items-center">
        <%= for favorite <- @wishlist do %>
          <!-- Wishlist Item -->
          <div class="wishlist-item">
            <%= live_component(@socket, SpaceGoodsWeb.ProductCardComponent,
              id: "product-card-#{favorite.product.id}",
              product: favorite.product,
              on_wishlist_page: true,
              locale: @locale
            ) %>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  @impl true
  def handle_params(params, _url, socket) do
    # Default to "en" if `locale` is not provided
    locale = Map.get(params, "locale", "en")
    {:noreply, assign(socket, locale: locale)}
  end

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

  def handle_event("remove_from_wishlist", %{"id" => product_id_string}, socket) do
    user = socket.assigns.current_user
    product_id = String.to_integer(product_id_string)

    case SpaceGoods.Accounts.remove_from_wishlist(user, product_id) do
      :ok ->
        updated_wishlist = SpaceGoods.Accounts.list_wishlist(user.id)
        new_socket = assign(socket, wishlist: updated_wishlist)
        new_socket = put_flash(new_socket, :info, "Product has been removed from wishlist")

        # send :clear_flash after 2 seconds
        Process.send_after(self(), :clear_flash, 2000)
        {:noreply, new_socket}

      {:error, :not_found} ->
        new_socket = put_flash(socket, :error, "Product was not found in wishlist")
        # send :clear_flash after 2 seconds
        Process.send_after(self(), :clear_flash, 2000)
        {:noreply, new_socket}

      {:error, reason} ->
        new_socket =
          put_flash(
            socket,
            :error,
            "There was an error removing the product from wishlist: #{reason}"
          )

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
