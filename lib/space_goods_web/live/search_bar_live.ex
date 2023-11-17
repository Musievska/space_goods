defmodule SpaceGoodsWeb.SearchBarLive do
  use SpaceGoodsWeb, :live_view

  alias SpaceGoods.Products

  on_mount {SpaceGoodsWeb.UserAuth, :mount_current_user}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, product: "", matches: [], loading: false)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id="search-bar" class="flex p-10 justify-center ">
      <.form phx-submit="search" phx-change="suggest" class="flex ">
        <.input
          type="text"
          name="product"
          value={@product}
          placeholder={gettext("Search for Space Goods...")}
          autofocus
          autocomplete="off"
          list="matches"
          phx-debounce="500"
          class="flex-grow p-2 rounded-l-lg"
        />

        <button>
          <.icon
            name="hero-magnifying-glass"
            class="ml-1 h-8 w-8 hover:animate-bounce text-red-500"
          />
        </button>
      </.form>

      <datalist id="matches">
        <option :for={{name, description} <- @matches} value={name}>
          <%= description %>
        </option>
      </datalist>
    </div>
    """
  end

  @impl true
  def handle_event("suggest", %{"product" => prefix}, socket) do
    matches = Products.suggest(prefix)
    {:noreply, assign(socket, matches: matches)}
  end

  @impl true
  def handle_event("search", %{"product" => product}, socket) do
    send(socket.parent_pid, {:run_search, product})

    socket =
      assign(socket,
        product: product,
        loading: true
      )

    {:noreply, socket}
  end

  @impl true
  def handle_event("clear", _params, socket) do
    {:noreply, assign(socket, product: "")}
  end
end
