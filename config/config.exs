# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :ex_chat,
  ecto_repos: [ExChat.Repo]

# Configures the endpoint
config :ex_chat, ExChatWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "D1N63VFYOPsKwj3n9HRj9LCsATxOahm/tDcEfhA6wEj9SNBRS+pMgmwnFgpGE0o3",
  render_errors: [view: ExChatWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ExChat.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
