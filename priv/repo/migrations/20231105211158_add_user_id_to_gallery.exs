defmodule SpaceGoods.Repo.Migrations.AddUserIdToGallery do
  use Ecto.Migration

  def change do
    alter table(:gallery) do
      add :user_id, references(:users, on_delete: :nothing), null: false
    end

    create index(:gallery, [:user_id])
  end
end
