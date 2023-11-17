defmodule SpaceGoodsWeb.ConfirmOrderLive do
  use SpaceGoodsWeb, :live_view

  alias SpaceGoods.Accounts
  alias SpaceGoods.Shopping

  on_mount {SpaceGoodsWeb.UserAuth, :mount_current_user}

  def mount(_params, _session, socket) do
    user_id = socket.assigns.current_user.id
    # Fetch the cart details and the checkout form for the user.
    cart = Shopping.get_cart(user_id)
    # Assuming that Checkout data is also available after `handle_event("save",...)` is called
    checkout = Accounts.get_or_create_checkout(user_id)

    {:ok, assign(socket, cart: cart, checkout: checkout, order_confirmed: false)}
  end

  def handle_event("confirm_order", _params, socket) do
    user_id = socket.assigns.current_user.id
    # Clear the cart after confirming the order
    Shopping.clear_cart(user_id)

    # Send an order confirmation email or perform other order confirmation steps here

    # Update the socket to reflect that the order has been confirmed
    {:noreply, assign(socket, :order_confirmed, true)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id="confirmation-wrapper">
      <h1>Order Confirmation</h1>
      <div id="order-details">
        <!-- Render checkout details -->
        <h2>Shipping Information:</h2>
        <p>First Name: <%= @checkout.first_name %></p>
        <p>Last Name: <%= @checkout.last_name %></p>
        <!-- Include other checkout details -->

        <!-- Render cart items -->
        <h2>Cart Items:</h2>
        <ul>
          <%= for item <- @cart.items do %>
            <li>
              <%= item.name %> - Quantity: <%= item.quantity %>, Price: <%= item.price %>
            </li>
          <% end %>
        </ul>
        <!-- Render total price if available -->
        <p>Total Price: <%= @cart.total_price %></p>
        <!-- Confirm order button -->
        <button phx-click="confirm_order">Confirm Order</button>
        <!-- Show confirmation message if order is confirmed -->
        <%= if @order_confirmed do %>
          <p>Your order has been confirmed! Thank you for shopping with us.</p>
        <% end %>
      </div>
    </div>
    """
  end
end
