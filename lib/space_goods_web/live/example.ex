# defmodule SpaceGoodsWeb.Example do
#   use SpaceGoodsWeb, :live_view

#   alias SpaceGoods.Products

#   on_mount {SpaceGoodsWeb.UserAuth, :mount_current_user}

#   @impl true
#   def mount(%{"locale" => locale}, _session, socket) do
#     categories = Products.get_unique_categories()
#     products = Products.list_products(%{filters: %{}})

#     {:ok,
#      assign(socket,
#        locale: locale,
#        products: products,
#        categories: categories,
#        filters: %{},
#        page: 1,
#        per_page: 10
#      )}
#   end

#   # queries are working but they are not being applied to the page afrer reloads

#   def render(assigns) do
#     ~H"""
#     <div class="mx-auto max-w-4xl">
#       <%= live_render(@socket, SpaceGoodsWeb.SearchBarLive,
#         id: "search-bar-component"
#       ) %>

#       <div class="flex justify-between mb-8 rounded-lg">
#         <form phx-change="filter">
#           <select
#             name="filters[category]"
#             class="form-select w-64 py-2 px-3 rounded-lg border border-red-500"
#           >
#             <option value="" selected={@filters["category"] == ""}>
#               All Categories
#             </option>
#             <%= for category <- @categories do %>
#               <option value={category} selected={@filters["category"] == category}>
#                 <%= category %>
#               </option>
#             <% end %>
#           </select>
#         </form>
#         <form phx-change="sort">
#           <select
#             name="sort_by"
#             class="form-select w-64 py-2 px-3 rounded-lg border border-red-500"
#           >
#             <option value="default">Sort By</option>
#             <option value="price_asc">Price (Low to High)</option>
#             <option value="price_desc">Price (High to Low)</option>
#             <option value="rating">Rating</option>
#           </select>
#         </form>
#       </div>
#       <div class="grid grid-cols-4 sm:grid-cols-2 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6 mx-auto max-w-4xl">
#         <%= for product <- @products do %>
#           <%= live_component(@socket, SpaceGoodsWeb.ProductCardComponent,
#             flash: @flash,
#             product: product,
#             id: "product-card-#{product.id}"
#           ) %>
#         <% end %>
#       </div>
#     </div>
#     <script src="/js/app.js">
#     </script>
#     """
#   end

#   # @impl true
#   # def handle_event("filter", %{"filters" => filters}, socket) do
#   #   products = Products.list_products(filters)
#   #   {:noreply, assign(socket, products: products, filters: filters)}
#   # end

#   # @impl true
#   # def handle_event("sort", %{"sort_by" => sort_by}, socket) do
#   #   filters = Map.put(socket.assigns.filters, "sort_by", sort_by)
#   #   products = Products.list_products(filters)
#   #   {:noreply, assign(socket, products: products, sort_by: sort_by)}
#   # end

#   @impl true
#   def handle_event("filter", %{"filters" => filters}, socket) do
#     # Check if locale is nil, and if so, set a default value (e.g., "en")
#     locale = socket.assigns.locale || "en"
#     # Extract sort_by from filters if it's present
#     sort_by = Map.get(filters, "sort_by", socket.assigns.sort_by)

#     # Remove sort_by from filters as it's handled separately
#     filters = Map.delete(filters, "sort_by")

#     # Merge the new filters with any existing filters
#     new_filters = Map.merge(socket.assigns.filters, filters)

#     # Generate a query string from the new filters and sort_by
#     query_params = Map.put(new_filters, "sort_by", sort_by)
#     query_string = URI.encode_query(query_params)

#     # Create the URL for the filtered and sorted view, including the locale
#     url = ~p"/#{locale}/products?#{query_string}"

#     # You might have a separate function to handle fetching products with both filters and sort_by
#     products = Products.list_products(query_params)

#     # Update the socket assigns and navigate to the new URL
#     updated_socket =
#       socket
#       |> assign(sort_by: sort_by)
#       |> assign(filters: new_filters)
#       |> assign(products: products)

#     {:noreply, push_patch(updated_socket, to: url)}
#   end

#   @impl true
#   def handle_event("sort", %{"sort_by" => sort_by}, socket) do
#     # Check if locale is nil, and if so, set a default value (e.g., "en")
#     locale = socket.assigns.locale || "en"
#     # Add the sort_by parameter to the existing filters
#     new_filters = Map.put(socket.assigns.filters, "sort_by", sort_by)
#     # Generate a query string from the new filters
#     query_string = URI.encode_query(new_filters)
#     # Create the URL for the sorted view, including the locale
#     url = ~p"/#{locale}/products?#{query_string}"
#     # Fetch the sorted products
#     products = Products.list_products(new_filters)
#     # Update the socket assigns and navigate to the new URL
#     {:noreply, assign(socket, products: products, sort_by: sort_by) |> push_patch(to: url)}
#   end

#   @impl true
#   def handle_params(params, _url, socket) do
#     # Extract the sort_by and category parameters from the params map
#     sort_by = Map.get(params, "sort_by")
#     category = Map.get(params, "category")

#     # Update the socket assigns with the sort_by and category values
#     updated_socket =
#       socket
#       |> assign(sort_by: sort_by)
#       |> assign(category: category)

#     {:noreply, updated_socket}
#   end

#   @impl true
#   def handle_event("change_per_page", %{"per_page" => per_page}, socket) do
#     per_page = String.to_integer(per_page)
#     {:noreply, push_patch(socket, to: "/products?page=1&per_page=#{per_page}")}
#   end

#   @impl true
#   def handle_event("add_to_wishlist", %{"id" => id}, socket) do
#     user = socket.assigns.current_user
#     {:ok, _favorite} = SpaceGoods.Accounts.add_to_wishlist(user.id, id)
#     {:noreply, socket |> put_flash(:info, "Added to wishlist")}
#   end

#   @impl true
#   def handle_event("more_details", %{"id" => id}, socket) do
#     {:noreply, push_navigate(socket, to: "/products/#{id}")}
#   end

#   @impl true
#   def handle_info({:run_search, product}, socket) do
#     socket =
#       assign(socket,
#         products: Products.search_by_name(product),
#         loading: false
#       )

#     {:noreply, socket}
#   end

#   # def handle_info({:put_flash, type, message}, _params, socket) do
#   #   {:noreply, put_flash(socket, type, message)}
#   # end
# end
# defmodule SpaceGoodsWeb.ProductsLive do
#   use SpaceGoodsWeb, :live_view

#   alias SpaceGoods.Products

#   on_mount {SpaceGoodsWeb.UserAuth, :mount_current_user}

#   @impl true
#   def mount(%{"locale" => locale}, _session, socket) do
#     categories = Products.get_unique_categories()
#     products = Products.list_products(%{filters: %{}})

#     {:ok,
#      assign(socket,
#        locale: locale,
#        products: products,
#        categories: categories,
#        filters: %{},
#        page: 1,
#        per_page: 6
#      )}
#   end

#   def render(assigns) do
#     ~H"""
#     <div class="mx-auto max-w-8xl">
#       <%= live_render(@socket, SpaceGoodsWeb.SearchBarLive,
#         id: "search-bar-component"
#       ) %>
#       <div class="flex justify-between mb-8 rounded-lg">
#         <form phx-change="filter">
#           <select
#             name="filters[category]"
#             class="form-select w-30 py-2 px-3 rounded-lg border border-red-500"
#           >
#             <option value="" selected={@filters["category"] == ""}>
#               <%= gettext("Categories") %>
#             </option>
#             <%= for category <- @categories do %>
#               <option value={category} selected={@filters["category"] == category}>
#                 <%= category %>
#               </option>
#             <% end %>
#           </select>
#         </form>
#         <form phx-change="sort">
#           <select
#             name="sort_by"
#             class="form-select w-30 py-2 px-3 rounded-lg border border-red-500"
#           >
#             <option value="default"><%= gettext("Sort By") %></option>
#             <option value="price_asc"><%= gettext("Price (Low to High)") %></option>
#             <option value="price_desc">
#               <%= gettext("Price (High to Low)") %>
#             </option>
#             <option value="rating"><%= gettext("Rating") %></option>
#           </select>
#         </form>
#       </div>
#       <div class="grid grid-cols-1 md:grid-cols-3 sm:grid-cols-2 gap-10">
#         <%= for product <- @products do %>
#           <%= live_component(@socket, SpaceGoodsWeb.ProductCardComponent,
#             flash: @flash,
#             product: product,
#             locale: @locale,
#             # This is not the wishlist page, do not render remove btn
#             on_wishlist_page: false,
#             current_user: @current_user,
#             id: "product-card-#{product.id}"
#           ) %>
#         <% end %>
#       </div>
#       <div class="footer">
#         <div class="pagination">
#           <.link
#             :if={@options.page > 1}
#             navigate={
#               ~p"/#{@locale}/products?#{%{@options | page: @options.page - 1}}"
#             }
#           >
#             <%= gettext("Previous") %>
#           </.link>

#           <.link
#             :for={{page_number, current_page?} <- pages(@options, @products_count)}
#             class={if current_page?, do: "active text-red-500", else: ""}
#             navigate={~p"/#{@locale}/products?#{%{@options | page: page_number}}"}
#           >
#             <%= page_number %>
#           </.link>

#           <.link
#             :if={@more_pages?}
#             navigate={
#               ~p"/#{@locale}/products?#{%{@options | page: @options.page + 1}}"
#             }
#           >
#             <%= gettext("Next") %>
#           </.link>
#         </div>
#       </div>
#     </div>
#     <script src="/js/app.js">
#     </script>
#     """
#   end

#   def handle_params(params, _uri, socket) do
#     page = param_to_integer(params["page"], 1)
#     per_page = param_to_integer(params["per_page"], 6)

#     options = %{
#       page: page,
#       per_page: per_page
#     }

#     products =
#       SpaceGoods.Products.list_paginated_products(%{
#         filters: socket.assigns.filters,
#         page: page,
#         per_page: per_page
#       })

#     socket = assign(socket, products: products, options: options)

#     socket =
#       assign(socket,
#         products: products,
#         options: options,
#         products_count: SpaceGoods.Products.count_products(),
#         more_pages?: more_pages?(options, SpaceGoods.Products.count_products()),
#         pages: pages(options, SpaceGoods.Products.count_products())
#       )

#     {:noreply, socket}
#   end

#   @impl true
#   def handle_event("filter", %{"filters" => new_filters}, socket) do
#     IO.inspect(new_filters, label: "New Filters")
#     # Reset page and sort_by values if the category has changed
#     filters =
#       if new_filters["category"] != socket.assigns.filters["category"] do
#         %{"category" => new_filters["category"], "sort_by" => "default"}
#       else
#         new_filters
#       end

#     options = %{page: 1, per_page: socket.assigns.per_page}
#     products = SpaceGoods.Products.list_paginated_products(%{filters: filters, page: 1, per_page: socket.assigns.per_page})
#      # Fetch the count of products for the selected category
#     products_count = SpaceGoods.Products.count_products_in_category(filters["category"])

#     socket =
#       socket
#       |> assign(:filters, filters)
#       |> assign(:products, products)
#       |> assign(:options, options)
#       |> assign(:page, 1)
#       |> assign(:products_count, products_count)
#       |> assign(:more_pages?, more_pages?(options, products_count))
#       |> assign(:pages, pages(options, products_count))

#       # IO.inspect(socket.assigns, label: "Socket Assigns")

#      # Update the URL to reflect the current filters and page
#   new_url = "/#{socket.assigns.locale}/products?category=#{filters["category"]}&page=1"
#   {:noreply, push_patch(socket, to: new_url)}
#   end

#   @impl true
#   def handle_event("sort", %{"sort_by" => sort_by}, socket) do
#     filters = Map.put(socket.assigns.filters, "sort_by", sort_by)
#     products = Products.list_products(filters)
#     {:noreply, assign(socket, products: products, sort_by: sort_by)}
#   end

#   @impl true
#   def handle_event("change_per_page", %{"per_page" => per_page}, socket) do
#     per_page = String.to_integer(per_page)
#     {:noreply, push_patch(socket, to: ~p"/#{@locale}/products?page=1&per_page=#{per_page}")}
#   end

#   @impl true
#   def handle_event("add_to_cart", %{"id" => id}, socket) do
#     user = socket.assigns.current_user
#     cart_id = socket.assigns.cart_id

#     cart =
#       SpaceGoods.Shopping.get_or_create_cart(%{user_id: user && user.id, session_id: cart_id})

#     {:ok, _cart_item} = SpaceGoods.Shopping.add_product_to_cart(cart, id)
#     socket = put_flash(socket, :info, "Added to cart")
#     {:noreply, socket}
#   end

#   @impl true
#   def handle_event("show-flash", _, socket) do
#     new_socket = put_flash(socket, :info, "Product is added to cart")
#     Process.send_after(self(), :clear_flash, 2000)
#     {:noreply, new_socket}
#   end

#   @impl true
#   def handle_event("add_to_wishlist", %{"id" => id}, socket) do
#     user = socket.assigns.current_user

#     case SpaceGoods.Accounts.add_to_wishlist(user.id, id) do
#       {:ok, :added} ->
#         new_socket = socket |> put_flash(:info, "Added to wishlist")
#         # send :clear_flash after 2 seconds
#         Process.send_after(self(), :clear_flash, 2000)
#         {:noreply, new_socket}

#       {:error, :already_in_wishlist} ->
#         new_socket = socket |> put_flash(:error, "Product is already in wishlist")
#         # send :clear_flash after 2 seconds
#         Process.send_after(self(), :clear_flash, 2000)
#         {:noreply, new_socket}
#     end
#   end

#   @impl true
#   def handle_info({:run_search, product}, socket) do
#     socket =
#       assign(socket,
#         products: Products.search_by_name(product),
#         loading: false
#       )

#     {:noreply, socket}
#   end

#   # function to clear flash,need to be called in handle_event and add timer(2000)
#   @impl true
#   def handle_info(:clear_flash, socket) do
#     {:noreply, clear_flash(socket)}
#   end

#   def handle_info({:put_flash, type, message}, _params, socket) do
#     {:noreply, put_flash(socket, type, message)}
#   end

#   # pagination helper functions
#   defp param_to_integer(nil, default), do: default

#   defp param_to_integer(param, default) do
#     case Integer.parse(param) do
#       {number, _} -> number
#       :error -> default
#     end
#   end

#   def more_pages?(options, product_count) do
#     options.page * options.per_page < product_count
#   end

#   defp pages(options, product_count) do
#     page_count = ceil(product_count / options.per_page)

#     for page_number <- (options.page - 2)..(options.page + 2),
#         page_number > 0 do
#       if page_number <= page_count do
#         current_page? = page_number == options.page
#         {page_number, current_page?}
#       end
#     end
#   end

#   defp pages(options, donation_count) do
#     page_count = ceil(donation_count / options.per_page)

#     for page_number <- (options.page - 2)..(options.page + 2),
#         page_number > 0 do
#       if page_number <= page_count do
#         current_page? = page_number == options.page
#         {page_number, current_page?}
#       end
#     end
#   end

# end
