defmodule SpaceGoodsWeb.ShoppingModalComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <div id="shoppingModal" class="fixed inset-0 z-50 overflow-auto bg-smoke-light flex">
      <div class="relative p-8 bg-white w-full max-w-md m-auto flex-col flex">
        <span class="absolute top-0 right-0 pt-4 pr-4 cursor-pointer" phx-click="hide_modal">&times;</span>
        <div>
          <h2 class="text-2xl font-semibold mb-2">Item Added to Cart!</h2>
          <div class="mb-4">
            <p>Would you like to continue shopping or proceed to checkout?</p>
          </div>
          <div class="flex space-x-4">
            <a href="/products" class="w-1/2 p-4 text-lg font-semibold bg-blue-500 text-white rounded">Continue Shopping</a>
            <a href="/cart" class="w-1/2 p-4 text-lg font-semibold bg-green-500 text-white rounded">Proceed to Checkout</a>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
