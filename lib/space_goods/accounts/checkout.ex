defmodule SpaceGoods.Accounts.Checkout do
  use Ecto.Schema
  import Ecto.Changeset

  schema "checkouts" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :city, :string
    field :address, :string
    field :zip, :string
    field :delivery_date, :utc_datetime
    field :shipping_same_as_billing, :boolean
    belongs_to :user, SpaceGoods.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(checkout, attrs) do
    checkout
    |> cast(attrs, [
      :first_name,
      :last_name,
      :email,
      :city,
      :address,
      :zip,
      :delivery_date,
      :shipping_same_as_billing,
      :user_id
    ])
    |> validate_required([
      :first_name,
      :last_name,
      :email,
      :city,
      :address,
      :zip,
      :delivery_date,
      :user_id
    ])
    |> validate_delivery_date()
  end

  # validation for delivery date, to be in day after tomorrow or later
  defp validate_delivery_date(changeset) do
    validate_change(changeset, :delivery_date, fn :delivery_date, delivery_date ->
      # Getting the day after tomorrow
      day_after_tomorrow = DateTime.utc_now() |> Timex.add(Timex.Duration.from_days(2))

      case DateTime.compare(delivery_date, day_after_tomorrow) do
        # lt means "less than"
        :lt -> [{:delivery_date, "must be the day after tomorrow or later"}]
        # Any other result (i.e., :gt or :eq) is fine
        _ -> []
      end
    end)
  end
end
