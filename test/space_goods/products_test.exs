defmodule SpaceGoods.ProductsTest do
  use SpaceGoods.DataCase

  alias SpaceGoods.Products

  describe "products" do
    alias SpaceGoods.Products.Product

    import SpaceGoods.ProductsFixtures

    @invalid_attrs %{
      name: nil,
      description: nil,
      category: nil,
      price: nil,
      rating: nil,
      image_url: nil
    }

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Products.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Products.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      valid_attrs = %{
        name: "some name",
        description: "some description",
        category: "some category",
        price: "120.5",
        rating: 42,
        image_url: "some image_url"
      }

      assert {:ok, %Product{} = product} = Products.create_product(valid_attrs)
      assert product.name == "some name"
      assert product.description == "some description"
      assert product.category == "some category"
      assert product.price == Decimal.new("120.5")
      assert product.rating == 42
      assert product.image_url == "some image_url"
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()

      update_attrs = %{
        name: "some updated name",
        description: "some updated description",
        category: "some updated category",
        price: "456.7",
        rating: 43,
        image_url: "some updated image_url"
      }

      assert {:ok, %Product{} = product} = Products.update_product(product, update_attrs)
      assert product.name == "some updated name"
      assert product.description == "some updated description"
      assert product.category == "some updated category"
      assert product.price == Decimal.new("456.7")
      assert product.rating == 43
      assert product.image_url == "some updated image_url"
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_product(product, @invalid_attrs)
      assert product == Products.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Products.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Products.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Products.change_product(product)
    end
  end
end
