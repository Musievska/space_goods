defmodule SpaceGoods.Repo.Migrations.AddSessionIdToCarts do
  use Ecto.Migration

  def change do
    alter table(:carts) do
      add :session_id, :string
    end

    # index for faster lookups
    create index(:carts, [:session_id])
  end
end
