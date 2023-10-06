defmodule SpaceGoodsWeb.LanguageSelectorLive do
  use SpaceGoodsWeb, :live_component

  alias SpaceGoods.Accounts
  alias SpaceGoods.Repo
  alias SpaceGoods.Accounts.User

  def render(assigns) do
    ~H"""
    <select phx-change="set_locale" value={@locale}>
      <option value="en" selected={(@locale == "en" and "selected") or nil}>English</option>
      <option value="bg" selected={(@locale == "bg" and "selected") or nil}>Bulgarian</option>
      <!-- add more languages that you want to appear in the menu -->
    </select>
    """
  end

  def handle_event("set_locale", %{"value" => locale}, socket) do
    # If user is logged in, save their preferred language
    if current_user = socket.assigns[:current_user] do
      update_user_language(current_user, locale)
    end

    # Update the locale in the session and in the component's state
    {:noreply, assign(socket, locale: locale)}
  end

  defp update_user_language(%User{} = user, locale) do
    user
    |> Ecto.Changeset.change(preferred_language: locale)
    |> Repo.update()
  end

  defp update_user_language(_, _), do: :ok
end
