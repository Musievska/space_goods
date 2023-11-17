defmodule SpaceGoodsWeb.CheckoutLive do
  use SpaceGoodsWeb, :live_view

  alias SpaceGoods.Accounts
  alias SpaceGoods.Shopping
  alias SpaceGoods.Accounts.Checkout

  on_mount {SpaceGoodsWeb.UserAuth, :mount_current_user}

  def mount(socket) do
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    changeset = Accounts.change_checkout(%Checkout{user_id: socket.assigns.current_user.id})

    socket =
      socket
      |> assign(:form, to_form(changeset))
      |> assign(:button_clicked, false)

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div id="checkout-wrapper" class="container mx-auto px-4 gap-10">
      <%= if @button_clicked do %>
        <div
          id="thank-you-message"
          class="mt-10 py-12 text-center bg-red-500 shadow-md rounded-lg mx-auto max-w-2xl"
        >
          <p class="text-lg text-white font-semibold">
            Thank you for your order! Your order has been successfully accepted.
          </p>
        </div>
      <% else %>
      <div>
        <.form
          for={@form}
          id="checkout-form"
          phx-change="validate"
          phx-submit="save"
          class="flex flex-col gap-10"
        >
          <div id="shipping-info">
            <!--check for phx-debounce="blur" -->
            <h1
              class="text-red-500 text-xl font-bold p-4"
              style="color: red; font-size: 1.25rem;"
            >
              <!-- Inline styles for red and bigger text -->
              <%= gettext("Delivery Information") %>
            </h1>

            <.input
              field={@form[:first_name]}
              type="text"
              label={gettext("First Name")}
            />
            <.input
              field={@form[:last_name]}
              type="text"
              label={gettext("Last Name")}
            />
            <.input field={@form[:email]} type="text" label={gettext("Email")} />
            <.input field={@form[:city]} type="text" label={gettext("City")} />
            <.input field={@form[:address]} type="text" label={gettext("Address")} />
            <.input
              field={@form[:zip]}
              type="text"
              inputmode="numeric"
              label={gettext("Zip")}
            />
            <.input
              field={@form[:delivery_date]}
              type="datetime-local"
              label={gettext("Delivery Date")}
            />
            <.input
              field={@form[:shipping_same_as_billing]}
              type="checkbox"
              label={gettext("Shipping info same as billing info")}
            />
            <.button class="" type="submit" phx-hook="FinishPurchase" phx-click="clear_cart">
              <%= gettext("Save") %>
            </.button>
          </div>
        </.form>
      </div>
      <% end %>
    </div>
    """
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

  def handle_event("validate", %{"checkout" => checkout_params}, socket) do
    changeset =
      %Checkout{}
      |> Accounts.change_checkout(checkout_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  def handle_event("save", %{"checkout" => checkout_params}, socket) do
    IO.inspect(checkout_params)
    user_id = socket.assigns.current_user.id
    checkout_params_with_user = Map.put(checkout_params, "user_id", user_id)
    socket = assign(socket, :button_clicked, true)

    # Attempt to get or create the checkout
    case Accounts.get_or_create_checkout(user_id) do
      {:ok, checkout} ->
        # Now that we have a checkout, either found or created,
        # we proceed to change it with the new parameters
        changeset = Accounts.change_checkout(checkout, checkout_params_with_user)

        if changeset.valid? do
          # Here you would update the checkout with the new params
          case Repo.update(changeset) do
            {:ok, _updated_checkout} ->
              # If the update is successful, navigate to the confirm order page
              {:noreply, push_navigate(socket, to: "/confirm-order")}

            {:error, _changeset} ->
              # If there was a problem with the update, reassign the changeset to the socket
              {:noreply, assign(socket, :changeset, changeset)}
          end
        else
          # If the changeset is not valid, reassign it to the socket
          {:noreply, assign(socket, :changeset, changeset)}
        end

      {:error, changeset} ->
        # If there was an issue creating the checkout, assign the changeset to the socket
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
