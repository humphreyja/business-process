# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :blackboard,
  ecto_repos: [Blackboard.Repo],
  authorization_server_sign_in: "http://localhost:4000/?client_key=blackboard",
  authorization_server_sign_out: "http://localhost:4000/sign-out/?client_key=blackboard"

config :jwt,
  secret_base: "sso_standard_secret_1234567890",
  client_secret: "blackboard_secret"

# Configures the endpoint
config :blackboard, Blackboard.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "5w9qkFooRtKpnC4tVmpdLvsO73HO5Ol6ccBKhA2t2RT6zBXNDET2+4AOZIvmc8ef",
  render_errors: [view: Blackboard.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Blackboard.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
