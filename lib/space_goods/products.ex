defmodule SpaceGoods.Products do
  @moduledoc """
  The Products context.
  """

  import Ecto.Query, warn: false
  alias SpaceGoods.Repo
  alias SpaceGoods.Products.Product

  def list_products(filters \\ %{}) do
    Product
    |> apply_category_filter(filters["category"])
    |> apply_sorting(filters["sort_by"] || "default")
    |> Repo.all()
  end

  def get_product!(id), do: Repo.get!(Product, id)

  def get_suggested_products(product) do
    Product
    |> where([p], p.category == ^product.category and p.id != ^product.id)
    |> Repo.all()
    |> Enum.take_random(4)
  end

  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end

  def get_products_by_ids(product_ids) do
    from(p in Product, where: p.id in ^product_ids)
    |> Repo.all()
  end

  def list_products_id(%{"ids" => ids}) do
    from(p in Product, where: p.id in ^ids)
    |> Repo.all()
  end

  defp apply_category_filter(query, nil), do: query
  defp apply_category_filter(query, ""), do: query

  defp apply_category_filter(query, category) when is_binary(category) do
    where(query, [p], p.category == ^category)
  end

  defp apply_sorting(query, "price_asc"), do: order_by(query, asc: :price)
  defp apply_sorting(query, "price_desc"), do: order_by(query, desc: :price)
  defp apply_sorting(query, "rating"), do: order_by(query, desc: :rating)
  defp apply_sorting(query, _), do: query

  defp valid_sort_by(sort_by) when sort_by in ~w(price_asc price_desc rating), do: sort_by
  defp valid_sort_by(_), do: "default"

  def get_unique_categories do
    Product
    |> select([p], p.category)
    |> distinct(true)
    |> Repo.all()
  end
end
