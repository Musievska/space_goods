defmodule SpaceGoodsWeb.LandingPageLive do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    Phoenix.View.render(SpaceGoodsWeb.PageView, "home.html.leex", assigns)
  end
end
