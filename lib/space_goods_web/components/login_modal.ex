defmodule SpaceGoodsWeb.LoginModal do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div
      id="loginModal"
      class="fixed inset-0 z-50 overflow-auto bg-smoke-light flex"
    >
      <div class="relative p-8 bg-white w-full max-w-md m-auto flex-col flex">
        <span
          class="absolute top-0 right-0 pt-4 pr-4 cursor-pointer"
          phx-click="hide_modal"
        >
          &times;
        </span>
        <div>
          <h2 class="text-2xl font-semibold mb-2">You are not logged in!</h2>
          <div class="mb-4">
            <p>Please log in or register to continue.</p>
          </div>
          <div class="flex space-x-4">
            <a
              href="/users/log_in"
              class="w-1/2 p-4 text-lg font-semibold bg-blue-500 text-white rounded"
            >
              Log In
            </a>
            <a
              href="/users/register"
              class="w-1/2 p-4 text-lg font-semibold bg-green-500 text-white rounded"
            >
              Register
            </a>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
