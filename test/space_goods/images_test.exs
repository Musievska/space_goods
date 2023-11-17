defmodule SpaceGoods.ImagesTest do
  use SpaceGoods.DataCase

  alias SpaceGoods.Images

  describe "images" do
    alias SpaceGoods.Images.Image

    import SpaceGoods.ImagesFixtures

    @invalid_attrs %{image_url: nil}

    test "list_images/0 returns all images" do
      image = image_fixture()
      assert Images.list_images() == [image]
    end

    test "get_image!/1 returns the image with given id" do
      image = image_fixture()
      assert Images.get_image!(image.id) == image
    end

    test "create_image/1 with valid data creates a image" do
      valid_attrs = %{image_url: "some image_url"}

      assert {:ok, %Image{} = image} = Images.create_image(valid_attrs)
      assert image.image_url == "some image_url"
    end

    test "create_image/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Images.create_image(@invalid_attrs)
    end

    test "update_image/2 with valid data updates the image" do
      image = image_fixture()
      update_attrs = %{image_url: "some updated image_url"}

      assert {:ok, %Image{} = image} = Images.update_image(image, update_attrs)
      assert image.image_url == "some updated image_url"
    end

    test "update_image/2 with invalid data returns error changeset" do
      image = image_fixture()
      assert {:error, %Ecto.Changeset{}} = Images.update_image(image, @invalid_attrs)
      assert image == Images.get_image!(image.id)
    end

    test "delete_image/1 deletes the image" do
      image = image_fixture()
      assert {:ok, %Image{}} = Images.delete_image(image)
      assert_raise Ecto.NoResultsError, fn -> Images.get_image!(image.id) end
    end

    test "change_image/1 returns a image changeset" do
      image = image_fixture()
      assert %Ecto.Changeset{} = Images.change_image(image)
    end
  end

  describe "photos" do
    alias SpaceGoods.Images.Photo

    import SpaceGoods.ImagesFixtures

    @invalid_attrs %{photo_url: nil}

    test "list_photos/0 returns all photos" do
      photo = photo_fixture()
      assert Images.list_photos() == [photo]
    end

    test "get_photo!/1 returns the photo with given id" do
      photo = photo_fixture()
      assert Images.get_photo!(photo.id) == photo
    end

    test "create_photo/1 with valid data creates a photo" do
      valid_attrs = %{photo_url: "some photo_url"}

      assert {:ok, %Photo{} = photo} = Images.create_photo(valid_attrs)
      assert photo.photo_url == "some photo_url"
    end

    test "create_photo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Images.create_photo(@invalid_attrs)
    end

    test "update_photo/2 with valid data updates the photo" do
      photo = photo_fixture()
      update_attrs = %{photo_url: "some updated photo_url"}

      assert {:ok, %Photo{} = photo} = Images.update_photo(photo, update_attrs)
      assert photo.photo_url == "some updated photo_url"
    end

    test "update_photo/2 with invalid data returns error changeset" do
      photo = photo_fixture()
      assert {:error, %Ecto.Changeset{}} = Images.update_photo(photo, @invalid_attrs)
      assert photo == Images.get_photo!(photo.id)
    end

    test "delete_photo/1 deletes the photo" do
      photo = photo_fixture()
      assert {:ok, %Photo{}} = Images.delete_photo(photo)
      assert_raise Ecto.NoResultsError, fn -> Images.get_photo!(photo.id) end
    end

    test "change_photo/1 returns a photo changeset" do
      photo = photo_fixture()
      assert %Ecto.Changeset{} = Images.change_photo(photo)
    end
  end

  describe "images" do
    alias SpaceGoods.Images.Image

    import SpaceGoods.ImagesFixtures

    @invalid_attrs %{name: nil, image_locations: nil}

    test "list_images/0 returns all images" do
      image = image_fixture()
      assert Images.list_images() == [image]
    end

    test "get_image!/1 returns the image with given id" do
      image = image_fixture()
      assert Images.get_image!(image.id) == image
    end

    test "create_image/1 with valid data creates a image" do
      valid_attrs = %{name: "some name", image_locations: ["option1", "option2"]}

      assert {:ok, %Image{} = image} = Images.create_image(valid_attrs)
      assert image.name == "some name"
      assert image.image_locations == ["option1", "option2"]
    end

    test "create_image/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Images.create_image(@invalid_attrs)
    end

    test "update_image/2 with valid data updates the image" do
      image = image_fixture()
      update_attrs = %{name: "some updated name", image_locations: ["option1"]}

      assert {:ok, %Image{} = image} = Images.update_image(image, update_attrs)
      assert image.name == "some updated name"
      assert image.image_locations == ["option1"]
    end

    test "update_image/2 with invalid data returns error changeset" do
      image = image_fixture()
      assert {:error, %Ecto.Changeset{}} = Images.update_image(image, @invalid_attrs)
      assert image == Images.get_image!(image.id)
    end

    test "delete_image/1 deletes the image" do
      image = image_fixture()
      assert {:ok, %Image{}} = Images.delete_image(image)
      assert_raise Ecto.NoResultsError, fn -> Images.get_image!(image.id) end
    end

    test "change_image/1 returns a image changeset" do
      image = image_fixture()
      assert %Ecto.Changeset{} = Images.change_image(image)
    end
  end
end
