# lib/spacegoods_web/components/search_bar_component.ex
defmodule SpaceGoodsWeb.SearchBarComponent do
  use Phoenix.Component

  alias Spacegoods.Products

  def search_bar(assigns) do
    ~H"""
    <div id="search-bar">
      <form phx-submit="search" phx-change="suggest">
        <input
          type="text"
          name="product"
          value={@product}
          placeholder="Search for Space Goods"
          autofocus
          autocomplete="off"
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

      <div :if={@loading} class="loader">Loading...</div>
    </div>
    """
  end

  def handle_event("suggest", %{"product" => prefix}, socket) do
    matches = Products.suggest(prefix)
    {:noreply, assign(socket, matches: matches)}
  end

  def handle_event("search", %{"product" => product}, socket) do
    send(self(), {:run_search, product})

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
