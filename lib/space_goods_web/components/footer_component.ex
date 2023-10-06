# lib/space_goods_web/components/footer_component.ex
defmodule SpaceGoodsWeb.FooterComponent do
  use Phoenix.Component

  slot :center, required: true

  def render(assigns) do
    ~H"""
    <footer class="bg-gray-800 text-white py-4">
      <div class="center-section text-center">
        <%= render_slot(@center) %>
      </div>
    </footer>
    """
  end
end
