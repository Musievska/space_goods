defmodule SpaceGoodsWeb.ProfileImageUploadLive do
  use SpaceGoodsWeb, :live_view

  alias SpaceGoods.Accounts
  alias SpaceGoods.Accounts.User

  on_mount {SpaceGoodsWeb.UserAuth, :mount_current_user}

  @s3_bucket "uploadsliveview"
  @s3_url "//#{@s3_bucket}.s3.eu-north-1.amazonaws.com"
  @s3_region "eu-north-1"

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(form: Accounts.change_profile_image(%User{}))
      |> allow_upload(
        :profile_image,
        accept: ~w(.png .jpeg .jpg),
        max_entries: 1,
        max_file_size: 10_000_000,
        external: &presign_upload/2
      )

    {:ok, socket}
  end

  def handle_event("cancel", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :profile_image, ref)}
  end

  def handle_event("validate", %{"profile_image" => params}, socket) do
    changeset =
      %User{}
      |> Accounts.change_profile_image(params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", _params, socket) do
    image_location =
      consume_uploaded_entries(socket, :profile_image, fn _meta, entry ->
        {:ok, Path.join(@s3_url, filename(entry))}
      end)

    params = Map.put(socket.assigns.form.params, "profile_image", image_location)
    # Ensure image_location is a string
    image_location_string = List.first(image_location)

    case SpaceGoods.Accounts.update_profile_image(
           socket.assigns.current_user,
           image_location_string
         ) do
      {:ok, user} ->
        {:noreply, assign(socket, :user, user)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  def handle_info({:user_updated, user}, socket) do
    {:noreply, assign(socket, :user, user)}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp presign_upload(entry, socket) do
    config = %{
      region: @s3_region,
      access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
      secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY")
    }

    {:ok, fields} =
      SimpleS3Upload.sign_form_upload(config, @s3_bucket,
        key: filename(entry),
        content_type: entry.client_type,
        max_file_size: socket.assigns.uploads.profile_image.max_file_size,
        expires_in: :timer.hours(1)
      )

    metadata = %{
      uploader: "S3",
      key: filename(entry),
      url: @s3_url,
      fields: fields
    }

    {:ok, metadata, socket}
  end

  defp filename(entry) do
    "#{entry.uuid}-#{entry.client_name}"
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>Update Your Profile Image</h1>

      <.form for={@form} phx-submit="save" phx-change="validate">
        <div class="hint">
          Upload your profile image (max <%= trunc(
            @uploads.profile_image.max_file_size / 1_000_000
          ) %> MB)
        </div>

        <div class="drop" phx-drop-target={@uploads.profile_image.ref}>
          <.live_file_input upload={@uploads.profile_image} /> or drag and drop here
        </div>

        <.error :for={err <- upload_errors(@uploads.profile_image)}>
          <%= Phoenix.Naming.humanize(err) %>
        </.error>

        <div :for={entry <- @uploads.profile_image.entries} class="entry">
          <.live_img_preview entry={entry} />

          <div class="progress">
            <div class="value">
              <%= entry.progress %>%
            </div>
            <div class="bar">
              <span style={"width: #{entry.progress}%"}></span>
            </div>
            <.error :for={err <- upload_errors(@uploads.profile_image, entry)}>
              <%= Phoenix.Naming.humanize(err) %>
            </.error>
          </div>

          <a phx-click="cancel" phx-value-ref={entry.ref}>
            &times;
          </a>
        </div>

        <.button phx-disable-with="Uploading...">
          Update Profile Image
        </.button>
      </.form>

      <div id="profile-image">
        <img src={@current_user.profile_image_url} alt="Profile Image" />
      </div>
    </div>
    """
  end
end
