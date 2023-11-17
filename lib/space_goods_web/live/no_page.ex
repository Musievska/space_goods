defmodule SpaceGoodsWeb.NoPage do
  use SpaceGoodsWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div id="no-page">
      <h1><%= gettext("Nothing to see here!") %></h1>
      <p>
        <%= gettext("Go back to earth!") %>
      </p>
      <.link navigate={~p"/"}>
        <.button><%= gettext("Go to home page") %></.button>
      </.link>
    </div>
    """
  end
end
