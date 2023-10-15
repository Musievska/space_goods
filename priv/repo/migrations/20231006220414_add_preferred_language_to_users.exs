defmodule SpaceGoods.Repo.Migrations.AddPreferredLanguageToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :preferred_language, :string
    end
  end
end
