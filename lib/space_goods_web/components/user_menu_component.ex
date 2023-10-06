defmodule SpaceGoodsWeb.UserMenuComponent do
  use Phoenix.Component
  import Phoenix.LiveView.Router

  def render(assigns) do
    ~H"""
    <div class="flex items-center">
      <img src="/icons/hamburger.png" alt="Menu" class="mr-4 cursor-pointer" />
      <div class="relative">
        <ul class="absolute right-0 z-10 flex flex-col items-start gap-2 px-4 py-2 bg-white shadow-lg">
          <%= if assigns[:current_user] do %>
            <li class="text-[0.8125rem] leading-6 text-zinc-900">
              <%= assigns[:current_user].email %>
            </li>
            <li>
              <.link
                href={Routes.live_path(@socket, SpaceGoodsWeb.UserSettingsLive, :edit)}
                class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
              >
                Settings
              </.link>
            </li>
            <li>
              <.link
                href={Routes.user_session_path(@socket, :delete)}
                method="delete"
                class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
              >
                Log out
              </.link>
            </li>
          <% else %>
            <li>
              <.link
                href={Routes.live_path(@socket, SpaceGoodsWeb.UserRegistrationLive, :new)}
                class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
              >
                Register
              </.link>
            </li>
            <li>
              <.link
                href={Routes.live_path(@socket, SpaceGoodsWeb.UserLoginLive, :new)}
                class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
              >
                Log in
              </.link>
            </li>
          <% end %>
        </ul>
      </div>
    </div>
    """
  end
end
