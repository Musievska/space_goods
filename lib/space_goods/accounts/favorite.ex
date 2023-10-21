defmodule SpaceGoods.Accounts.Favorite do
  use Ecto.Schema
  import Ecto.Changeset

  schema "favorites" do
    belongs_to :user, SpaceGoods.Accounts.User
    belongs_to :product, SpaceGoods.Products.Product

    timestamps()
  end

  @doc false
  def changeset(favorite, attrs) do
    favorite
    |> cast(attrs, [:user_id, :product_id])
    |> validate_required([:user_id, :product_id])
    |> assoc_constraint(:user)
    |> assoc_constraint(:product)
  end
end
