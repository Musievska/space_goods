defmodule SpaceGoodsWeb.ShippingInfoLive do
  use SpaceGoodsWeb, :live_view

  alias SpaceGoods.Accounts

  on_mount {SpaceGoodsWeb.UserAuth, :mount_current_user}

  @impl true
  def mount(_params, _session, socket) do
    changeset = Accounts.change_shipping_info(%SpaceGoods.Accounts.ShippingInfo{})

    form = to_form(changeset, as: :shipping_info)

    {:ok, assign(socket, form: form)}
  end

  @impl true
  def handle_event("validate", %{"shipping_info" => shipping_info_params}, socket) do
    changeset =
      %SpaceGoods.Accounts.ShippingInfo{}
      |> SpaceGoods.Accounts.ShippingInfo.changeset(shipping_info_params)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("save", %{"shipping_info" => shipping_info_params}, socket) do
    save_shipping_info(socket, shipping_info_params)
  end

  def save_shipping_info(socket, shipping_info_params) do
    # Create a changeset from the shipping_info_params map
    changeset =
      %SpaceGoods.Accounts.ShippingInfo{}
      |> SpaceGoods.Accounts.change_shipping_info(shipping_info_params)

    case Accounts.create_shipping_info(changeset) do
      {:ok, shipping_info} ->
        {:noreply,
         socket
         |> put_flash(:info, "Shipping Information saved successfully")
         |> push_patch(to: Routes.user_path(socket, :shipping_settings))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         assign(socket,
           form: to_form(Ecto.Changeset.apply_changes(changeset), as: :shipping_info)
         )}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id="shipping-info">
      <h1 class="p-4 flex">Shipping Information</h1>
      <div>
        <.form
          for={@form}
          id="shipping-info-form"
          phx-submit="save"
          phx-change="validate"
        >
          <.input
            field={@form[:address]}
            type="text"
            phx-debounce="500"
            label="Address"
            placeholder="Enter your address"
            autocomplete="off"
          />
          <.input
            field={@form[:city]}
            type="text"
            placeholder="Enter your city"
            autocomplete="off"
            phx-debounce="500"
            label="City"
          />
          <.input
            field={@form[:state]}
            placeholder="Enter your state"
            autocomplete="off"
            type="text"
            phx-debounce="500"
            label="State"
          />
          <.input
            field={@form[:zip]}
            type="text"
            placeholder="Enter your zip code"
            phx-debounce="500"
            label="ZIP Code"
          />
          <.input
            field={@form[:end_date]}
            type="datetime-local"
            label={gettext("End date")}
          />
          <div>
            <.button phx-disable-with="Saving...">Save</.button>
          </div>
        </.form>
      </div>
      <% IO.inspect(@form) %>
    </div>
    """
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
