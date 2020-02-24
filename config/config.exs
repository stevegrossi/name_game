# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :name_game, NameGameWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "V5xtVxX+/fHotgC2JINaYBbBSCIXPztYW02KAnSNcVHJ24SshL++XSLTL1Kh3JRy",
  render_errors: [view: NameGameWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: NameGame.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "XnY3DezZ"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
