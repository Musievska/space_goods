defmodule SpaceGoodsWeb.SearchBarLive do
  use SpaceGoodsWeb, :live_view

  alias SpaceGoods.Products


  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, product: "", matches: [], loading: false)}
  end

  def render(assigns) do
    product = Map.get(assigns, :product, "")

    ~H"""
    <div id="search-bar">
      <form phx-submit="search" phx-change="suggest">
        <input
          type="text"
          name="product"
          value={@product}
          placeholder="Search for Space Goods"
          autofocus
          autocomplete="on"
          readonly={@loading}
          list="matches"
          phx-debounce="1000"
        />

        <button>
          <img src="/images/search.svg" />
        </button>
      </form>

      <datalist id="matches">
        <option :for={{name, description} <- @matches} value={name}>
          <%= description %>
        </option>
      </datalist>

      <%!-- <div :if={@loading} class="loader">Loading...</div> --%>
    </div>
    """
  end

  def handle_event("suggest", %{"product" => prefix}, socket) do
    matches = Products.suggest(prefix)
    {:noreply, assign(socket, matches: matches)}
  end

  def handle_event("search", %{"product" => product}, socket) do
    send(socket.parent_pid, {:run_search, product})

    socket =
      assign(socket,
        product: product,
        loading: true
      )

    {:noreply, socket}
  end


  def handle_info({:run_search, product}, socket) do
    socket =
      assign(socket,
        products: Products.search_by_name(product),
        loading: false
      )

    {:noreply, socket}
  end


end
