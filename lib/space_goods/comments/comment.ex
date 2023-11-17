defmodule SpaceGoods.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :timestamp, :utc_datetime
    field :comment_text, :string
    field :user_id, :id
    field :product_id, :id

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:comment_text, :timestamp])
    |> validate_required([:comment_text, :timestamp])
  end
end
