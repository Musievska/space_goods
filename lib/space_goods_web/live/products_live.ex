defmodule SpaceGoodsWeb.ProductsLive do
  use SpaceGoodsWeb, :live_view

  alias SpaceGoods.Products
  alias SpaceGoods.Shopping

  import SpaceGoodsWeb.SearchBarLive

  on_mount {SpaceGoodsWeb.UserAuth, :mount_current_user}

  @impl true
  def mount(_params, _session, socket) do
    categories = Products.get_unique_categories()
    products = Products.list_products(%{filters: %{}})

    {:ok,
     assign(socket,
       products: products,
       categories: categories,
       filters: %{},
       page: 1,
       per_page: 10,
       loading: false
     )}
  end

  @impl true
  def handle_event("filter", %{"filters" => filters}, socket) do
    products = Products.list_products(filters)
    {:noreply, assign(socket, products: products, filters: filters)}
  end

  @impl true
  def handle_event("sort", %{"sort_by" => sort_by}, socket) do
    filters = Map.put(socket.assigns.filters, "sort_by", sort_by)
    products = Products.list_products(filters)
    {:noreply, assign(socket, products: products, sort_by: sort_by)}
  end

  # @impl true
  # def handle_event("change_per_page", %{"per_page" => per_page}, socket) do
  #   per_page = String.to_integer(per_page)
  #   {:noreply, push_patch(socket, to: "/products?page=1&per_page=#{per_page}")}
  # end

  def handle_event("more_details", %{"id" => id}, socket) do
    {:noreply, push_navigate(socket, to: "/products/#{id}")}
  end

  def handle_event("add_to_cart", %{"id" => id}, socket) do
    user = socket.assigns.current_user
    cart_id = socket.assigns.cart_id

    cart =
      SpaceGoods.Shopping.get_or_create_cart(%{user_id: user && user.id, session_id: cart_id})

    {:ok, _cart_item} = SpaceGoods.Shopping.add_product_to_cart(cart, id)

    {:noreply, socket |> put_flash(:info, "Added to cart")}
    IO.inspect(socket.assigns.flash)
  end

  def handle_info({:run_search, product}, socket) do
    products = Products.search_by_name(product)

    {:noreply, assign(socket, products: products)}
  end


  @impl true
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-4xl">
    <%= live_render(@socket, SpaceGoodsWeb.SearchBarLive, id: "search-bar") %>
      <div class="flex justify-between mb-8">
        <form phx-change="filter">
          <select name="filters[category]" class="form-select w-64 py-2 px-3">
            <option value="" selected={@filters["category"] == ""}>All Categories</option>
            <%= for category <- @categories do %>
              <option value={category} selected={@filters["category"] == category}>
                <%= category %>
              </option>
            <% end %>
          </select>
        </form>
        <form phx-change="sort">
          <select name="sort_by" class="form-select w-64 py-2 px-3">
            <option value="default">Sort By</option>
            <option value="price_asc">Price (Low to High)</option>
            <option value="price_desc">Price (High to Low)</option>
            <option value="rating">Rating</option>
          </select>
        </form>
      </div>
      <div class="grid grid-cols-4 sm:grid-cols-2 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6 mx-auto max-w-4xl">
        <%= for product <- @products do %>
          <div class="bg-white rounded-lg overflow-hidden shadow-md">
            <img
              id={"product-image-" <> Integer.to_string(product.id)}
              loading="lazy"
              class="product-image w-full h-64 object-cover"
              src="/images/no_image.jpeg"
              data-src={"/images/#{String.replace(String.downcase(product.name), " ", "_")}.jpg?v=#{SpaceGoodsWeb.Helpers.asset_version()}"}
              alt={product.name}
              phx-hook="LoadImage"
            />
            <div class="p-6">
              <h2 class="text-xl font-semibold mb-2"><%= product.name %></h2>
              <p class="font-bold mb-2"><%= product.price %> $</p>
              <p class="mb-2">Rating: <%= product.rating %></p>
              <button phx-click="more_details" phx-value-id={product.id}>More Details</button>
              <button
                id={"add-to-cart-" <> Integer.to_string(product.id)}
                phx-hook="AddToCart"
                data-id={product.id}
                data-name={product.name}
                data-price={product.price}
                value={product.id}
              >
                <img src="images/cart.png" alt="Cart Image" class="round-image-padding w-20 h-20" />
              </button>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    <script src="/js/app.js">
    </script>
    """
  end
end
