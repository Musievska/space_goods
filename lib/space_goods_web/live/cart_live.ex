defmodule SpaceGoodsWeb.CartLive do
  use SpaceGoodsWeb, :live_view

  alias SpaceGoods.Shopping

  # @impl true
  # def mount(_params, session, socket) do
  #   # Fetch the user_id from the session
  #   user_id = Map.get(session, :user_id)

  #   # Fetch or create the cart for the user
  #   cart = Shopping.get_or_create_cart(user_id)

  #   # Assign the cart and user_id to the socket
  #   {:ok, assign(socket, cart: cart, user_id: user_id)}
  # end

  @impl true
  def handle_event("finish_order", _params, socket) do
    # Check if the user is logged in
    if socket.assigns.user_id do
      # Handle the order finishing logic here
      # ...
      # Show a modal indicating success
      {:noreply, push_event(socket, "show_success_modal", %{})}
    else
      # Prompt the user to log in or register
      # {:noreply, push_redirect(socket, to: Routes.auth_path(socket, :login))}
    end
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div>
      <!-- Display all the items added to the cart -->
      <%= for item <- @cart.cart_items do %>
        <!-- Render each cart item here -->
      <% end %>

      <!-- Implement a form for payment -->
      <form phx-submit="finish_order">
        <!-- Payment form fields go here -->

        <!-- Implement a button to finish the order -->
        <button type="submit">Finish Order</button>
      </form>
    </div>
    """
  end
end
