defmodule SpaceGoods.ImageProcessor do
  @image_dir "priv/static/images/"

  def resize_image(image_name) do
    path = Path.join(@image_dir, image_name)

    case File.exists?(path) do
      true ->
        {:ok, image} = Mogrify.open(path)

        image
        |> Mogrify.resize("200x200")
        |> Mogrify.save()

        :ok

      false ->
        IO.puts("Image not found: #{path}")
        :error
    end
  end
end
