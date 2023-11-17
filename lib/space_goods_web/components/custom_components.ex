defmodule SpaceGoodsWeb.CustomComponents do
  use Phoenix.Component

  import SpaceGoodsWeb.CoreComponents

  attr :expiration, :integer, default: 24
  slot :legal
  slot :inner_block, required: true

  def promo(assigns) do
    ~H"""
    <div class="promo">
      <div class="deal">
        <%= render_slot(@inner_block) %>
      </div>
      <div class="expiration">
        Deal expires in <%= @expiration %> hours
      </div>
      <div class="legal">
        <%= render_slot(@legal) %>
      </div>
    </div>
    """
  end

  def locale_btn(assigns) do
    current_lang = assigns.locale
    url = assigns.url

    other_lang = if current_lang == "en", do: "bg", else: "en"
    new_url = change_url(url, other_lang)

    ~H"""
    <div class="relative">
      <button
        class="dropdown-btn"
        phx-click={SpaceGoodsWeb.Layouts.App.toggle_locale_menu()}
      >
        <.icon
          name="hero-globe-europe-africa"
          class="ml-2 w-8 h-8 text-red-500 hover:animate-spin"
        >
        </.icon>
      </button>
      <ul
        class="dropdown-menu-arrow absolute right-0 mt-2 py-2 w-flex bg-red-500 rounded-lg shadow-xl border border-white"
        id="locale_menu"
        phx-click-away={SpaceGoodsWeb.Layouts.App.toggle_locale_menu()}
        hidden="true"
      >
        <li class="dropdown-item">
          <a href={url} class="text-white">
            <%= String.capitalize(current_lang) %>
          </a>
        </li>
        <li class="dropdown-item">
          <a href={new_url} class="text-white">
            <%= String.capitalize(other_lang) %>
          </a>
        </li>
      </ul>
    </div>
    """
  end

  defp change_url(url, locale) do
    parts = String.split(url, "/", trim: true)
    rest_of_url = Enum.slice(parts, 1..-1) |> Enum.join("/")
    "/#{locale}/#{rest_of_url}"
  end
end
