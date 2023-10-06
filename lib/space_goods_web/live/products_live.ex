defmodule SpaceGoodsWeb.ProductsLive do
  use SpaceGoodsWeb, :live_view

  import Phoenix.LiveView.Helpers

  alias SpaceGoods.Products

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


  @impl true
  def handle_event("change_per_page", %{"per_page" => per_page}, socket) do
    per_page = String.to_integer(per_page)
    {:noreply, push_patch(socket, to: "/products?page=1&per_page=#{per_page}")}
  end

  def handle_event("more_details", %{"id" => id}, socket) do
    {:noreply, push_navigate(socket, to: "/products/#{id}")}
  end

  def handle_event("add_to_cart", %{"id" => id}, socket) do
    # loading state/issue
    socket = assign(socket, loading: true)

    {:noreply,
     assign(socket, loading: false)
     |> push_patch(to: "/cart", flash: %{info: "Added to cart"})}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-2xl">
      <div class="flex justify-between mb-4">
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
      <div class="grid grid-cols-4 sm:grid-cols-2 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6 mx-auto max-w-2xl">
        <%= for product <- @products do %>
          <div class="bg-white rounded-lg overflow-hidden shadow-md" >
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
              <p class="font-bold mb-2">Price: <%= product.price %></p>
              <p class="mb-2">Rating: <%= product.rating %></p>
              <button phx-click="more_details" phx-value-id={product.id}>More Details</button>
              <button phx-click="add_to_cart" phx-value-id={product.id}>Add to Cart</button>
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


  # @impl true
  # def mount(_params, _session, socket) do
  #   categories = Products.get_unique_categories()
  #   {products, total_count} = Products.list_products(%{filters: %{}, cursor_params: %{limit: 10}})

  #   {:ok,
  #    assign(socket,
  #      products: products,
  #      categories: categories,
  #      filters: %{},
  #      total_count: total_count,
  #      page: 1,
  #      per_page: 10,
  #      loading: false
  #    )}
  # end


  # def handle_params(params, _uri, socket) do
  #   page = Map.get(params, "page", "1") |> String.to_integer()
  #   per_page = Map.get(params, "per_page", "10") |> String.to_integer()
  #   {products, _} = Products.list_products(%{filters: socket.assigns.filters, cursor_params: %{limit: per_page, after: params["after"], before: params["before"]}})

  #   {:noreply,
  #    assign(socket, products: products, total_count: length(products), page: page, per_page: per_page)}
  # end

  # defp more_pages?(page, per_page, total_count) do
  #   page * per_page < total_count
  # end

  # @impl true
  # def handle_event("filter", %{"filters" => filters}, socket) do
  #   page_data = Products.list_products(%{filters: filters, cursor_params: %{limit: socket.assigns.per_page}})

  #   {:noreply,
  #    assign(socket, products: page_data.entries, filters: filters, total_count: page_data.metadata.total_count, page: 1)}
  # end

  # @impl true
  # def handle_event("sort", %{"sort_by" => sort_by}, socket) do
  #   filters = socket.assigns.filters
  #   page = socket.assigns.page
  #   per_page = socket.assigns.per_page
  #   page_data = Products.list_products(%{filters: filters, cursor_params: %{limit: per_page, after: socket.assigns.after, before: socket.assigns.before}})

  #   {:noreply, assign(socket, products: page_data.entries, total_count: page_data.metadata.total_count, sort_by: sort_by)}
  # end

  # @impl true
  # def handle_event("change_per_page", %{"per_page" => per_page}, socket) do
  #   per_page = String.to_integer(per_page)
  #   {:noreply, push_patch(socket, to: "/products?page=1&per_page=#{per_page}")}
  # end

  # def handle_event("more_details", %{"id" => id}, socket) do
  #   {:noreply, push_navigate(socket, to: "/products/#{id}")}
  # end

  # def handle_event("add_to_cart", %{"id" => id}, socket) do
  #   # loading state/issue
  #   socket = assign(socket, loading: true)

  #   {:noreply,
  #    assign(socket, loading: false)
  #    |> push_patch(to: "/cart", flash: %{info: "Added to cart"})}
  # end
