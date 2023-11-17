defmodule SpaceGoods.Repo.Migrations.RemoveUserIdFromGallery do
  use Ecto.Migration

  def change do
    alter table(:gallery) do
      remove :user_id
    end
  end
end
