defmodule SpaceGoodsWeb.Helpers do
  def asset_version do
    DateTime.utc_now() |> DateTime.to_unix()
  end
end
