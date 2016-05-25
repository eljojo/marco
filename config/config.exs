# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :marco,
  ecto_repos: [Marco.Repo]

# Configures the endpoint
config :marco, Marco.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "c/pfrA4gSzAN9SIUd5kLlZ/dl7ctlRkJZmL5QZKpbBP5pvpmcrxNUzJkNCynM97G",
  render_errors: [view: Marco.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Marco.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
