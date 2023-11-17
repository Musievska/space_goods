defmodule SpaceGoods.ImagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SpaceGoods.Images` context.
  """

  @doc """
  Generate a image.
  """
  def image_fixture(attrs \\ %{}) do
    {:ok, image} =
      attrs
      |> Enum.into(%{
        image_url: "some image_url"
      })
      |> SpaceGoods.Images.create_image()

    image
  end

  @doc """
  Generate a photo.
  """
  def photo_fixture(attrs \\ %{}) do
    {:ok, photo} =
      attrs
      |> Enum.into(%{
        photo_url: "some photo_url"
      })
      |> SpaceGoods.Images.create_photo()

    photo
  end

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
      |> SpaceGoods.Images.create_image()

    image
  end
end
