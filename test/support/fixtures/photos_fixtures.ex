defmodule SpaceGoods.PhotosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SpaceGoods.Photos` context.
  """

  @doc """
  Generate a photo.
  """
  def photo_fixture(attrs \\ %{}) do
    {:ok, photo} =
      attrs
      |> Enum.into(%{
        photo_url: "some photo_url"
      })
      |> SpaceGoods.Photos.create_photo()

    photo
  end

  @doc """
  Generate a photo.
  """
  def photo_fixture(attrs \\ %{}) do
    {:ok, photo} =
      attrs
      |> Enum.into(%{
        name: "some name",
        photo_locations: ["option1", "option2"]
      })
      |> SpaceGoods.Photos.create_photo()

    photo
  end
end
