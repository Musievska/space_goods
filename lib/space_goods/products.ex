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

# defmodule SpaceGoods.Products do
#   @moduledoc """
#   The Products context.
#   """

#   import Ecto.Query, warn: false
#   alias SpaceGoods.Repo
#   alias SpaceGoods.Products.Product

#   def list_products(filters \\ %{}, page_params \\ %{}) do
#     query = from(p in Product)

#     # Apply category filter if present
#     query =
#       case filters["category"] do
#         nil -> query
#         "" -> query
#         category -> where(query, [p], p.category == ^category)
#       end

#     # Apply sorting
#     sort_by = valid_sort_by(filters["sort_by"] || "default")
#     query = apply_sorting(query, sort_by)

#     # Apply pagination with Paginator
#     cursor_params = Keyword.merge(
#       [limit: 10, cursor_fields: [:inserted_at, :id]],
#       Map.to_list(page_params)
#     )

#     page = Repo.paginate(query, cursor_params)

#     {page.entries, page.metadata.total_count}
#   end

#   def get_product!(id), do: Repo.get!(Product, id)

#   def create_product(attrs \\ %{}) do
#     %Product{}
#     |> Product.changeset(attrs)
#     |> Repo.insert()
#   end

#   def update_product(%Product{} = product, attrs) do
#     product
#     |> Product.changeset(attrs)
#     |> Repo.update()
#   end

#   def delete_product(%Product{} = product) do
#     Repo.delete(product)
#   end

#   def change_product(%Product{} = product, attrs \\ %{}) do
#     Product.changeset(product, attrs)
#   end

#   defp apply_sorting(query, "price_asc"), do: order_by(query, asc: :price)
#   defp apply_sorting(query, "price_desc"), do: order_by(query, desc: :price)
#   defp apply_sorting(query, "rating"), do: order_by(query, desc: :rating)
#   defp apply_sorting(query, _), do: query

#   defp valid_sort_by(sort_by) when sort_by in ~w(price_asc price_desc rating), do: sort_by
#   defp valid_sort_by(_), do: "default"

#   def get_unique_categories do
#     Product
#     |> select([p], p.category)
#     |> distinct(true)
#     |> Repo.all()
#   end
# end
