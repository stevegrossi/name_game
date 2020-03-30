defmodule NameGame.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the endpoint when the application starts
      NameGameWeb.Endpoint,
      # Starts a worker by calling: NameGame.Worker.start_link(arg)
      # {NameGame.Worker, arg},
      {ConCache,
       [name: :data_cache, ttl_check_interval: :timer.minutes(1), global_ttl: :timer.hours(24)]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NameGame.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    NameGameWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
