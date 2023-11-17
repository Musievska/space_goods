defmodule SpaceGoods.Repo.Migrations.CreateGallery do
  use Ecto.Migration

  def change do
    create table(:gallery) do
      add :name, :string
      add :image_locations, {:array, :string}

      timestamps()
    end
  end
end
