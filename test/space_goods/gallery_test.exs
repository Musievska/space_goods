defmodule SpaceGoods.GalleryTest do
  use SpaceGoods.DataCase

  alias SpaceGoods.Gallery

  describe "gallery" do
    alias SpaceGoods.Gallery.Image

    import SpaceGoods.GalleryFixtures

    @invalid_attrs %{name: nil, image_locations: nil}

    test "list_gallery/0 returns all gallery" do
      image = image_fixture()
      assert Gallery.list_gallery() == [image]
    end

    test "get_image!/1 returns the image with given id" do
      image = image_fixture()
      assert Gallery.get_image!(image.id) == image
    end

    test "create_image/1 with valid data creates a image" do
      valid_attrs = %{name: "some name", image_locations: ["option1", "option2"]}

      assert {:ok, %Image{} = image} = Gallery.create_image(valid_attrs)
      assert image.name == "some name"
      assert image.image_locations == ["option1", "option2"]
    end

    test "create_image/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Gallery.create_image(@invalid_attrs)
    end

    test "update_image/2 with valid data updates the image" do
      image = image_fixture()
      update_attrs = %{name: "some updated name", image_locations: ["option1"]}

      assert {:ok, %Image{} = image} = Gallery.update_image(image, update_attrs)
      assert image.name == "some updated name"
      assert image.image_locations == ["option1"]
    end

    test "update_image/2 with invalid data returns error changeset" do
      image = image_fixture()
      assert {:error, %Ecto.Changeset{}} = Gallery.update_image(image, @invalid_attrs)
      assert image == Gallery.get_image!(image.id)
    end

    test "delete_image/1 deletes the image" do
      image = image_fixture()
      assert {:ok, %Image{}} = Gallery.delete_image(image)
      assert_raise Ecto.NoResultsError, fn -> Gallery.get_image!(image.id) end
    end

    test "change_image/1 returns a image changeset" do
      image = image_fixture()
      assert %Ecto.Changeset{} = Gallery.change_image(image)
    end
  end
end
