# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :sso,
  namespace: SSO,
  ecto_repos: [SSO.Repo]

config :jwt,
  secret_base: "sso_standard_secret_1234567890"

# Configures the endpoint
config :sso, SSO.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "h8Imqw/Hm4JynBYYZMywGzB2XNLubvuc/YbIWofBRxnGDOw/W+HgZNic0beYzwGO",
  render_errors: [view: SSO.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SSO.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ex_admin,
  repo: SSO.Repo,
  module: SSO,
  modules: [
    SSO.ExAdmin.Dashboard,
    SSO.ExAdmin.User,
    SSO.ExAdmin.Client
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :xain, :after_callback, {Phoenix.HTML, :raw}


# %% Coherence Configuration %%   Don't remove this line
config :coherence,
  user_schema: SSO.User,
  repo: SSO.Repo,
  module: SSO,
  logged_out_url: "/",
  email_from_name: "Your Name",
  email_from_email: "yourname@example.com",
  opts: [:invitable, :confirmable, :authenticatable, :recoverable, :lockable, :trackable, :unlockable_with_token, :registerable]

config :coherence, SSO.Coherence.Mailer,
  adapter: Swoosh.Adapters.Sendgrid,
  api_key: "your api key here"
# %% End Coherence Configuration %%
