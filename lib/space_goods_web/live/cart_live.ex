defmodule SpaceGoodsWeb.CartLive do
  use SpaceGoodsWeb, :live_view
  alias SpaceGoods.Shopping
  alias SpaceGoods.Products

  on_mount {SpaceGoodsWeb.UserAuth, :mount_current_user}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, cart_items: [])}
  end

  @impl true
  def handle_event("load_cart", %{"items" => items}, socket) do
    {:noreply, assign(socket, cart_items: items)}
  end

  def handle_event("remove_item", %{"id" => item_id}, socket) do
    IO.inspect({:expected, item_id}, label: "handle_event")

    # Ensure item_id is an integer
    product_id =
      case Integer.parse(item_id) do
        # Assume it's already an integer
        :error -> item_id
        # It was a string, but now it's converted to an integer
        {value, _} -> value
      end

    # Get the user_id from the socket if it's available or use a default value
    user_id =
      case socket.assigns do
        %{current_user: %SpaceGoods.Accounts.User{id: id}} -> id
        _ -> "default_session_id"
      end

    # Get or create the cart
    cart = Shopping.get_or_create_cart(%{user_id: user_id, session_id: "default_session_id"})

    # Find the cart item to be removed
    cart_item = Enum.find(cart.cart_items, &(&1.product_id == product_id))

    case cart_item do
      nil ->
        # Cart item not found; you might want to log an error or notify the user
        {:noreply, socket}

      _ ->
        # Remove the cart item from the database
        {:ok, _} = Shopping.remove_product_from_cart(cart_item.id)

        # Fetch the updated cart items from the database
        updated_cart_items = Shopping.get_cart_items_for_user(user_id)

        # Update the cart items on the client side
        {:noreply, assign(socket, cart_items: updated_cart_items)}
    end
  end

  def handle_event("remove_item", params, socket) do
    # Assuming the first item should be removed as a placeholder
    [item_to_remove | remaining_items] = socket.assigns.cart_items

    # Update the cart items on the client side
    {:noreply, assign(socket, cart_items: remaining_items)}
  end

  # Utility function to extract user_id from the socket
  defp get_user_id(socket) do
    case socket.assigns do
      %{current_user: %SpaceGoods.Accounts.User{id: id}} -> id
      _ -> nil
    end
  end

  # Handler for "increase_quantity" event
  def handle_event("increase_quantity", %{"value" => %{"id" => product_id}}, socket) do
    # Optimistically update the client-side UI
    updated_cart_items =
      update_cart_item_quantity(socket.assigns.cart_items, product_id, &(&1 + 1))

    socket = assign(socket, cart_items: updated_cart_items)

    user_id = get_user_id(socket)
    # Get or create the cart
    cart = Shopping.get_or_create_cart(%{user_id: user_id, session_id: "default_session_id"})

    # Find the cart item
    cart_item = Enum.find(cart.cart_items, &(&1.product_id == String.to_integer(product_id)))

    # Increment the quantity
    new_quantity = cart_item.quantity + 1

    # Update the quantity in the database
    {:ok, _} = Shopping.update_cart_item_quantity(cart_item.id, new_quantity)

    # Fetch the updated cart items from the database
    updated_cart_items = Shopping.get_cart_items_for_user(user_id)

    # Update the cart items on the client side
    {:noreply, assign(socket, cart_items: updated_cart_items)}
  end

  # Handler for "decrease_quantity" event
  def handle_event("decrease_quantity", %{"value" => %{"id" => product_id}}, socket) do
    # Optimistically update the client-side UI
    updated_cart_items =
      update_cart_item_quantity(socket.assigns.cart_items, product_id, &(&1 - 1))

    socket = assign(socket, cart_items: updated_cart_items)

    user_id = get_user_id(socket)
    # Get or create the cart
    cart = Shopping.get_or_create_cart(%{user_id: user_id, session_id: "default_session_id"})

    # Find the cart item
    cart_item = Enum.find(cart.cart_items, &(&1.product_id == String.to_integer(product_id)))

    # Decrement the quantity
    new_quantity = cart_item.quantity - 1

    # Update the quantity in the database
    {:ok, _} = Shopping.update_cart_item_quantity(cart_item.id, new_quantity)

    # Fetch the updated cart items from the database
    updated_cart_items = Shopping.get_cart_items_for_user(user_id)

    # Update the cart items on the client side
    {:noreply, assign(socket, cart_items: updated_cart_items)}
  end

  def handle_unexpected_error(:error, _function, _args, _opts) do
    {:error, "An unexpected error occurred"}
  end

  def handle_unexpected_error(_reason, _function, _args, _opts) do
    {:error, "An unexpected error occurred"}
  end

  # Utility function to update cart item quantity
  defp update_cart_item_quantity(cart_items, product_id, update_fn) do
    Enum.map(cart_items, fn item ->
      if Integer.to_string(item["id"]) == product_id do
        Map.update(item, "quantity", 0, update_fn)
      else
        item
      end
    end)
  end

  # Shorter handlers to handle unexpected params and update the UI
  def handle_event("increase_quantity", _params, socket) do
    user_id = get_user_id(socket)
    updated_cart_items = Shopping.get_cart_items_for_user(user_id)
    {:noreply, assign(socket, cart_items: updated_cart_items)}
  end

  def handle_event("decrease_quantity", _params, socket) do
    user_id = get_user_id(socket)
    updated_cart_items = Shopping.get_cart_items_for_user(user_id)
    {:noreply, assign(socket, cart_items: updated_cart_items)}
  end

  defp total_quantity(cart_items) do
    Enum.reduce(cart_items, 0, fn item, acc -> acc + item["quantity"] end)
  end

  defp total_price(cart_items) do
    Enum.reduce(cart_items, 0.0, fn item, acc -> acc + item["quantity"] * item["price"] end)
  end

  def handle_event("clear_cart", _value, socket) do
    case socket.assigns.current_user do
      nil ->
        {:noreply, assign(socket, :error, "No user signed in")}

      current_user ->
        case Shopping.clear_cart(current_user.id) do
          {:ok, _cart} ->
            {:noreply, assign(socket, :cart_items, [])}

          {:error, error} ->
            {:noreply, assign(socket, :error, error)}
        end
    end
  end

  def handle_event("finish_purchase", _value, socket) do
    {:noreply, push_navigate(socket, to: "/checkout")}
  end

  def handle_event("add_more_products", _value, socket) do
    {:noreply, push_navigate(socket, to: "/products")}
  end

  @impl true
  def render(assigns) do
    # IO.inspect(assigns, label: "Render Assigns")
    # cart_items = assigns[:cart_items] || []
    ~H"""
    <!-- component -->
    <div
      id="cart-page"
      phx-hook="CartPage"
      class="flex flex-col md:flex-row w-full h-full px-6 py-3 justify-center"
    >
      <!-- My Cart -->
      <%= if length(@cart_items) > 0 do %>
        <div class="w-full flex flex-col h-fit gap-4 p-4 ">
          <p class="text-red-500 text-xl font-extrabold">My cart</p>
          <!-- Product -->
          <%= for product <- @cart_items do %>
            <div class="flex flex-col p-4 text-lg font-semibold shadow-md border rounded-sm">
              <div class="flex flex-col md:flex-row gap-3 justify-between">
                <!-- Product Information -->
                <div class="flex flex-row gap-6 items-center">
                  <div class="w-28 h-28">
                    <img
                      id={"product-image-" <> Integer.to_string(String.to_integer(product["id"]))}
                      loading="lazy"
                      class="product-image w-full h-64 object-cover"
                      style="height: 100%;"
                      src="/images/no_image.jpeg"
                      data-src={"/images/#{String.replace(String.downcase(product["name"] ), " ", "_")}.jpg?v=#{SpaceGoodsWeb.Helpers.asset_version()}"}
                      alt={product["name"]}
                      phx-hook="LoadImage"
                    />
                  </div>
                  <div class="flex flex-col gap-1">
                    <p class="text-lg text-gray-800 font-semibold">
                      <%= product["name"] %>
                    </p>
                  </div>
                </div>
                <!-- Price Information -->
                <div class="self-center text-center">
                  <%!-- Add logic for coupon/need to render condin. --%>
                  <%!-- <p class="text-gray-600 font-normal text-sm line-through">$99.99
        <span class="text-emerald-500 ml-2">(-50% OFF)</span>
    </p> --%>
                  <p class="text-gray-800 font-normal text-xl">
                    $<%= product["price"] %>
                  </p>
                </div>
                <!-- Remove Product Icon -->
                <div
                  class="self-center"
                  data-id={product["id"]}
                  id={"remove-item-" <> product["id"]}
                  phx-hook="RemoveFromCart"
                >
                  <button class="" phx-click="remove_item" data-action="remove_item">
                    <.icon
                      name="hero-trash"
                      class="ml-1 w-8 h-8 text-red-500 hover:animate-bounce"
                    >
                    </.icon>
                  </button>
                </div>
              </div>
              <!-- Product Quantity -->
              <div
                class="flex flex-row self-center gap-1"
                data-id={product["id"]}
                id={"update-quantity-" <> product["id"]}
                phx-hook="UpdateQuantity"
              >
                <button
                  class="w-5 h-5 self-center rounded-full border border-black"
                  phx-click="decrease_quantity"
                  data-action="decrease_quantity"
                >
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke="black"
                    stroke-width="2"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                  >
                    <path d="M5 12h14" />
                  </svg>
                </button>
                <input
                  type="text"
                  readonly="readonly"
                  value={product["quantity"]}
                  class="w-10 h-10 text-center text-black text-sm outline-none border border-black rounded-sm"
                />
                <button
                  class="w-5 h-5 self-center rounded-full border border-black"
                  phx-click="increase_quantity"
                  data-action="increase_quantity"
                >
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    viewBox="0 0 24 24"
                    fill=""
                    stroke="black"
                    stroke-width="2"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                  >
                    <path d="M12 5v14M5 12h14" />
                  </svg>
                </button>
              </div>
            </div>
          <% end %>
        </div>
        <!-- Purchase Resume -->
        <div class="w-full md:w-1/2 flex flex-col h-fit gap-4 p-4 ">
          <p class="text-red-500 text-xl font-extrabold">
            <%= gettext("Purchase Resume") %>
          </p>
          <div class="flex flex-col p-4 gap-4 text-lg font-semibold shadow-md border rounded-sm">
            <div class="flex flex-row justify-between">
              <p class="text-gray-600"><%= gettext("Items") %></p>
              <p class="text-end font-bold"><%= total_quantity(@cart_items) %></p>
            </div>
            <hr class="bg-gray-200 h-0.5" />
            <div class="flex flex-row justify-between">
              <p class="text-gray-600"><%= gettext("Discount") %></p>
              <a class="text-gray-500 text-base underline" href="#">
                <%= gettext("Add") %>
              </a>
            </div>
            <hr class="bg-gray-200 h-0.5" />
            <div class="flex flex-row justify-between">
              <p class="text-gray-600"><%= gettext("Total") %></p>
              <div>
                <p class="text-end font-bold">
                  $<%= :erlang.float_to_binary(total_price(@cart_items),
                    decimals: 2
                  ) %>
                </p>
              </div>
            </div>
            <div class="flex gap-2">
              <button
                id="finish-button"
                phx-click="finish_purchase"
                class="transition-colors text-sm bg-red-600 hover:bg-red-700 p-2 rounded-sm w-full text-white shadow-md"
              >
                <%= gettext("FINISH") %>
              </button>

              <button
                phx-click="add_more_products"
                id="add-more-products-button"
                class="transition-colors text-sm bg-red border border-red-600 p-2 rounded-sm w-full text-gray-700 text-hover shadow-md"
              >
                <%= gettext("ADD MORE PRODUCTS") %>
              </button>
            </div>
          </div>
        </div>
      <% else %>
        <p><%= gettext("No items in cart.") %></p>
      <% end %>
    </div>
    <%!-- <script src="/js/app.js">
    </script> --%>
    """
  end
end
