defmodule SpaceGoods.CommentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SpaceGoods.Comments` context.
  """

  @doc """
  Generate a comment.
  """
  def comment_fixture(attrs \\ %{}) do
    {:ok, comment} =
      attrs
      |> Enum.into(%{
        comment_text: "some comment_text",
        timestamp: ~U[2023-10-23 09:24:00Z]
      })
      |> SpaceGoods.Comments.create_comment()

    comment
  end

  @doc """
  Generate a comment.
  """
  def comment_fixture(attrs \\ %{}) do
    {:ok, comment} =
      attrs
      |> Enum.into(%{
        comment_text: "some comment_text",
        timestamp: ~U[2023-10-23 09:27:00Z]
      })
      |> SpaceGoods.Comments.create_comment()

    comment
  end
end
