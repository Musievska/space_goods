defmodule SpaceGoodsWeb.Layouts do
  use SpaceGoodsWeb, :html

  import SpaceGoodsWeb.SearchBarComponent, only: [search_bar_component: 1]

  embed_templates "layouts/*"
end
