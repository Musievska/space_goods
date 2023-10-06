defmodule SpaceGoodsWeb.NavbarComponent do
  use Phoenix.Component

  alias SpaceGoodsWeb.UserMenuComponent

  # slot :home
  # slot :search_bar
  # slot :cart_icon

  def render(assigns) do
    ~H"""
    <nav class="navbar">
      <div class="navbar-brand">
        <a href="/" class="navbar-item">
          Space Goods
        </a>
      </div>
      <%!-- <div class="navbar-menu">
        <div class="navbar-start">
          <%= render_slot(@home) %>
          <%= render_slot(@search_bar) %>
        </div> --%>
      <%!-- <.user_menu_component current_user={@current_user} /> --%>
      <%!-- </div> --%>
    </nav>
    """
  end
end
