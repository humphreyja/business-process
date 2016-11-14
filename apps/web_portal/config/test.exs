use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :web_portal, WebPortal.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :web_portal, WebPortal.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: System.get_env("POSTGRES_DB") || "business_process_web_portal_dev",
  hostname: System.get_env("POSTGRES_HOST") || "localhost",
  user: System.get_env("POSTGRES_USER") || nil,
  pool: Ecto.Adapters.SQL.Sandbox
