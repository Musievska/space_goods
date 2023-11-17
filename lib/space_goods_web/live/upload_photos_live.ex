defmodule SpaceGoodsWeb.UploadPhotosLive do
  use Phoenix.LiveView

  alias SpaceGoods.Gallery
  alias SpaceGoods.Gallery.Image

  on_mount {SpaceGoodsWeb.UserAuth, :mount_current_user}

  import Phoenix.HTML
  import Phoenix.Router.Helpers
  import SpaceGoodsWeb.CoreComponents

  use Phoenix.VerifiedRoutes,
    endpoint: SpaceGoodsWeb.Endpoint,
    router: SpaceGoodsWeb.Router

  def mount(_params, _session, socket) do
    if connected?(socket), do: Gallery.subscribe()

    socket =
      assign(socket,
        form: to_form(Gallery.change_image(%Image{}))
      )

    socket =
      allow_upload(
        socket,
        :photos,
        accept: ~w(.png .jpeg .jpg),
        max_entries: 3,
        max_file_size: 10_000_000
      )

    {:ok, stream(socket, :images, Gallery.list_gallery())}
  end

  def handle_event("cancel", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :photos, ref)}
  end

  def handle_event("validate", %{"image" => params}, socket) do
    changeset =
      %Image{}
      |> Image.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"image" => params}, socket) do
    # copy temp file to priv/static/uploads/abc-1.png
    # URL path: /uploads/abc-1.png

    image_locations =
      consume_uploaded_entries(socket, :photos, fn meta, entry ->
        dest =
          Path.join([
            "priv",
            "static",
            "uploads",
            "#{entry.uuid}-#{entry.client_name}"
          ])

        File.cp!(meta.path, dest)

        url_path = static_path(socket, "/uploads/#{Path.basename(dest)}")

        {:ok, url_path}
      end)

    params = Map.put(params, "image_locations", image_locations)

    case Gallery.create_image(params) do
      {:ok, _image} ->
        changeset = Gallery.change_image(%Image{})
        {:noreply, assign_form(socket, changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  def handle_info({:image_created, image}, socket) do
    {:noreply, stream_insert(socket, :images, image, at: 0)}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  def render(assigns) do
    ~H"""
    <div id="image-upload-container" class="mt-8 max-w-4xl mx-auto">
      <h1 class="text-center text-2xl font-bold mx-auto text-red-500">
        Upload Your Images
      </h1>
      <div id="images" class="">
        <.form for={@form} phx-submit="save" phx-change="validate">
          <.input field={@form[:name]} placeholder="Image Title" />

          <div class="hint">
            Add up to <%= @uploads.photos.max_entries %> images
            (max <%= trunc(@uploads.photos.max_file_size / 1_000_000) %> MB each)
          </div>

          <div class="drop" phx-drop-target={@uploads.photos.ref}>
            <.live_file_input upload={@uploads.photos} /> or drag and drop here
          </div>

          <.error :for={err <- upload_errors(@uploads.photos)}>
            <%= Phoenix.Naming.humanize(err) %>
          </.error>

          <div :for={entry <- @uploads.photos.entries} class="entry">
            <.live_img_preview entry={entry} />

            <div class="progress">
              <div class="value">
                <%= entry.progress %>%
              </div>
              <div class="bar">
                <span style={"width: #{entry.progress}%"}></span>
              </div>
              <.error :for={err <- upload_errors(@uploads.photos, entry)}>
                <%= Phoenix.Naming.humanize(err) %>
              </.error>
            </div>

            <a phx-click="cancel" phx-value-ref={entry.ref}>
              &times;
            </a>
          </div>

          <.button phx-disable-with="Uploading...">
            Upload
          </.button>
        </.form>

        <div id="gallery" phx-update="stream">
          <div :for={{dom_id, image} <- @streams.images} id={dom_id}>
            <div
              :for={
                {image_location, index} <-
                  Enum.with_index(image.image_locations)
              }
              class="image"
            >
              <img src={image_location} />
              <div class="title">
                <%= image.name %> (<%= index + 1 %>)
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
