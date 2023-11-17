defmodule SpaceGoods.PhotosTest do
  use SpaceGoods.DataCase

  alias SpaceGoods.Photos

  describe "photos" do
    alias SpaceGoods.Photos.Photo

    import SpaceGoods.PhotosFixtures

    @invalid_attrs %{photo_url: nil}

    test "list_photos/0 returns all photos" do
      photo = photo_fixture()
      assert Photos.list_photos() == [photo]
    end

    test "get_photo!/1 returns the photo with given id" do
      photo = photo_fixture()
      assert Photos.get_photo!(photo.id) == photo
    end

    test "create_photo/1 with valid data creates a photo" do
      valid_attrs = %{photo_url: "some photo_url"}

      assert {:ok, %Photo{} = photo} = Photos.create_photo(valid_attrs)
      assert photo.photo_url == "some photo_url"
    end

    test "create_photo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Photos.create_photo(@invalid_attrs)
    end

    test "update_photo/2 with valid data updates the photo" do
      photo = photo_fixture()
      update_attrs = %{photo_url: "some updated photo_url"}

      assert {:ok, %Photo{} = photo} = Photos.update_photo(photo, update_attrs)
      assert photo.photo_url == "some updated photo_url"
    end

    test "update_photo/2 with invalid data returns error changeset" do
      photo = photo_fixture()
      assert {:error, %Ecto.Changeset{}} = Photos.update_photo(photo, @invalid_attrs)
      assert photo == Photos.get_photo!(photo.id)
    end

    test "delete_photo/1 deletes the photo" do
      photo = photo_fixture()
      assert {:ok, %Photo{}} = Photos.delete_photo(photo)
      assert_raise Ecto.NoResultsError, fn -> Photos.get_photo!(photo.id) end
    end

    test "change_photo/1 returns a photo changeset" do
      photo = photo_fixture()
      assert %Ecto.Changeset{} = Photos.change_photo(photo)
    end
  end

  describe "photos" do
    alias SpaceGoods.Photos.Photo

    import SpaceGoods.PhotosFixtures

    @invalid_attrs %{name: nil, photo_locations: nil}

    test "list_photos/0 returns all photos" do
      photo = photo_fixture()
      assert Photos.list_photos() == [photo]
    end

    test "get_photo!/1 returns the photo with given id" do
      photo = photo_fixture()
      assert Photos.get_photo!(photo.id) == photo
    end

    test "create_photo/1 with valid data creates a photo" do
      valid_attrs = %{name: "some name", photo_locations: ["option1", "option2"]}

      assert {:ok, %Photo{} = photo} = Photos.create_photo(valid_attrs)
      assert photo.name == "some name"
      assert photo.photo_locations == ["option1", "option2"]
    end

    test "create_photo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Photos.create_photo(@invalid_attrs)
    end

    test "update_photo/2 with valid data updates the photo" do
      photo = photo_fixture()
      update_attrs = %{name: "some updated name", photo_locations: ["option1"]}

      assert {:ok, %Photo{} = photo} = Photos.update_photo(photo, update_attrs)
      assert photo.name == "some updated name"
      assert photo.photo_locations == ["option1"]
    end

    test "update_photo/2 with invalid data returns error changeset" do
      photo = photo_fixture()
      assert {:error, %Ecto.Changeset{}} = Photos.update_photo(photo, @invalid_attrs)
      assert photo == Photos.get_photo!(photo.id)
    end

    test "delete_photo/1 deletes the photo" do
      photo = photo_fixture()
      assert {:ok, %Photo{}} = Photos.delete_photo(photo)
      assert_raise Ecto.NoResultsError, fn -> Photos.get_photo!(photo.id) end
    end

    test "change_photo/1 returns a photo changeset" do
      photo = photo_fixture()
      assert %Ecto.Changeset{} = Photos.change_photo(photo)
    end
  end
end
