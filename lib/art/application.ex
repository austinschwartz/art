defmodule Art.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Art.Repo,
      # Start the Telemetry supervisor
      ArtWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Art.PubSub},
      # Start the Endpoint (http/https)
      ArtWeb.Endpoint
      # Start a worker by calling: Art.Worker.start_link(arg)
      # {Art.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Art.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ArtWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
