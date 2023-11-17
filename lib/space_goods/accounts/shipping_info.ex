defmodule SpaceGoods.Accounts.ShippingInfo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "shipping_info" do
    field :address, :string
    field :city, :string
    field :state, :string
    field :zip, :string
    belongs_to :user, SpaceGoods.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(shipping_info, attrs) do
    shipping_info
    |> cast(attrs, [:address, :city, :state, :zip, :user_id])
    |> validate_required([:address, :city, :state, :zip, :user_id])
    |> validate_length(:address, max: 255)
    |> validate_length(:city, max: 100)
    |> validate_length(:state, max: 100)
    |> validate_format(:zip, ~r/^\d{4}$/, message: "is invalid")
  end
end
