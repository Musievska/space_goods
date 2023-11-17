defmodule SpaceGoods.GalleryFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SpaceGoods.Gallery` context.
  """

  @doc """
  Generate a image.
  """
  def image_fixture(attrs \\ %{}) do
    {:ok, image} =
      attrs
      |> Enum.into(%{
        image_locations: ["option1", "option2"],
        name: "some name"
      })
      |> SpaceGoods.Gallery.create_image()

    image
  end
end
