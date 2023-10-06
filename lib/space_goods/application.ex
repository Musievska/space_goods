defmodule SpaceGoods.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      SpaceGoodsWeb.Telemetry,
      # Start the Ecto repository
      SpaceGoods.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: SpaceGoods.PubSub},
      # Start Finch
      {Finch, name: SpaceGoods.Finch},
      # Start the Endpoint (http/https)
      SpaceGoodsWeb.Endpoint
      # Start a worker by calling: SpaceGoods.Worker.start_link(arg)
      # {SpaceGoods.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SpaceGoods.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SpaceGoodsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
