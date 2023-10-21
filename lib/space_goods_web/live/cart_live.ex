defmodule SpaceGoodsWeb.CartLive do
  use SpaceGoodsWeb, :live_view
  alias SpaceGoods.Shopping
  # Importing the Products context
  alias SpaceGoods.Products

  on_mount {SpaceGoodsWeb.UserAuth, :mount_current_user}

  def mount(_params, _session, socket) do
    {:ok, assign(socket, cart_items: [])}
  end

  def handle_event("load_cart", %{"items" => items}, socket) do
    IO.inspect(items, label: "Cart Items")
    {:noreply, assign(socket, cart_items: items)}
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
      class="flex flex-col md:flex-row w-full h-full px-14 py-7 justify-center"
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
                    <p class="text-lg text-gray-800 font-semibold"><%= product["name"] %></p>
                  </div>
                </div>
                <!-- Price Information -->
                <div class="self-center text-center">
                <%!-- Add logic for coupon/need to render condin. --%>
                  <%!-- <p class="text-gray-600 font-normal text-sm line-through">$99.99
                        <span class="text-emerald-500 ml-2">(-50% OFF)</span>
                    </p> --%>
                  <p class="text-gray-800 font-normal text-xl">$<%= product["price"] %></p>
                </div>
                <!-- Remove Product Icon -->
                <div class="self-center">
                  <button class="">
                    <svg
                      class=""
                      height="30px"
                      width="30px"
                      id="Layer_1"
                      style="enable-background:new 0 0 512 512;"
                      version="1.1"
                      viewBox="0 0 512 512"
                      xml:space="preserve"
                      xmlns="http://www.w3.org/2000/svg"
                      xmlns:xlink="http://www.w3.org/1999/xlink"
                    >
                      <g>
                        <path d="M400,113.3h-80v-20c0-16.2-13.1-29.3-29.3-29.3h-69.5C205.1,64,192,77.1,192,93.3v20h-80V128h21.1l23.6,290.7   c0,16.2,13.1,29.3,29.3,29.3h141c16.2,0,29.3-13.1,29.3-29.3L379.6,128H400V113.3z M206.6,93.3c0-8.1,6.6-14.7,14.6-14.7h69.5   c8.1,0,14.6,6.6,14.6,14.7v20h-98.7V93.3z M341.6,417.9l0,0.4v0.4c0,8.1-6.6,14.7-14.6,14.7H186c-8.1,0-14.6-6.6-14.6-14.7v-0.4   l0-0.4L147.7,128h217.2L341.6,417.9z" />
                        <g>
                          <rect height="241" width="14" x="249" y="160" />
                          <polygon points="320,160 305.4,160 294.7,401 309.3,401" />
                          <polygon points="206.5,160 192,160 202.7,401 217.3,401" />
                        </g>
                      </g>
                    </svg>
                  </button>
                </div>
              </div>
              <!-- Product Quantity -->
              <div class="flex flex-row self-center gap-1">
                <button class="w-5 h-5 self-center rounded-full border border-black">
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
                  class="w-8 h-8 text-center text-black text-sm outline-none border border-black rounded-sm"
                />
                <button class="w-5 h-5 self-center rounded-full border border-black">
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
            <p class="text-red-500 text-xl font-extrabold">Purchase Resume</p>
            <div class="flex flex-col p-4 gap-4 text-lg font-semibold shadow-md border rounded-sm">
              <div class="flex flex-row justify-between">
                <p class="text-gray-600">Subtotal (2 Items)</p>
                <p class="text-end font-bold">$99.98</p>
              </div>
              <hr class="bg-gray-200 h-0.5" />
              <div class="flex flex-row justify-between">
                <p class="text-gray-600">Discount Coupon</p>
                <a class="text-gray-500 text-base underline" href="#">Add</a>
              </div>
              <hr class="bg-gray-200 h-0.5" />
              <div class="flex flex-row justify-between">
                <p class="text-gray-600">Total</p>
                <div>
                  <p class="text-end font-bold">$103.88</p>
                </div>
              </div>
              <div class="flex gap-2">
                <button class="transition-colors text-sm bg-red-600 hover:bg-red-700 p-2 rounded-sm w-full text-white text-hover shadow-md">
                  FINISH
                </button>
                <button class="transition-colors text-sm bg-red border border-red-600 p-2 rounded-sm w-full text-gray-700 text-hover shadow-md">
                  ADD MORE PRODUCTS
                </button>
              </div>
            </div>
          </div>
        <% else %>
          <p>No items in cart.</p>
        <% end %>
    </div>
    <script src="/js/app.js">
    </script>
    """
  end
end
