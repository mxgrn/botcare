import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :botcare, Botcare.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "botcare_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :botcare, BotcareWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "LZHxQ1l+1AUdcDqcLoa0uo8PHOJRNbdhxmR0xzIFNTr9mPf3mrkGUB9QKKI794x7",
  server: false

# In test we don't send emails.
config :botcare, Botcare.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

System.put_env("CLOAK_KEY", "QMitIAKCydI/RTjYJYMLvLym4qUn67Ta4XoDZf8K0A0=")
System.put_env("BASIC_AUTH_USERNAME", "username")
System.put_env("BASIC_AUTH_PASSWORD", "password")
System.put_env("TELEGRAM_WEBHOOK_SECRET", "StXuzKARHjcdVvwcjWME")
