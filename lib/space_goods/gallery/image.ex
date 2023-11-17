defmodule SpaceGoods.Gallery.Image do
  use Ecto.Schema
  import Ecto.Changeset

  schema "gallery" do
    field :name, :string
    field :image_locations, {:array, :string}, default: []

    timestamps()
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [:name, :image_locations])
    |> validate_required([:name, :image_locations])
  end
end
