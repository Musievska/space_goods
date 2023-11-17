defmodule YourApp.Repo.Migrations.UpdateZipToString do
  use Ecto.Migration

  def change do
    alter table(:checkouts) do
      modify :zip, :string
    end
  end
end
