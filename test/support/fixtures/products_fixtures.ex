defmodule SpaceGoods.ProductsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SpaceGoods.Products` context.
  """

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        name: "some name",
        description: "some description",
        category: "some category",
        price: "120.5",
        rating: 42,
        image_url: "some image_url"
      })
      |> SpaceGoods.Products.create_product()

    product
  end
end
