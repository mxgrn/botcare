# Botcare!

This self-hosted webapp helps you quickly put your Telegram bots in and out of the "maintenance mode".

If you write Telegrab bots, you may occasionally face the following problem: a bot may need to go offline. One reason for
it may be moving the bot over to another host, or do some other non-trivial updates that require downtime. During such
periods, your bot's users should not be left in the dark by the bot silently swallowing their messages or actions.
Instead, a maintenance warning should be sent back to the users, and no unprocessed messages should accumulate in
Telegram's queue.

This is exactly what this app helps you with. After configuring your bots, you will be able to move them in and out of
the maintenance mode by a single click of a button.

## Note about (self-)hosting

This is meant to be a self-hosted app because it requires storing the bot's auth token in the database. It gets
encrypted, but the hosting party has access to the encryption key (stored as a Github secret).

However, should you prefer to trust someone like me hosting such an app for you, I might consider creating an extended,
multi-user version of this app as a service. In such case, [send me a tweet](https://twitter.com/mxgrn).

## Getting started

Configure a bot by providing its handle, token (ask BotFather), and the endpoint (the one you provided to setWebhook API
method). Optionally, type in a custom maintenance message specific for this bot (if omitted, a default one will be used).

<img width="598" alt="image" src="https://user-images.githubusercontent.com/33935/189493275-ecf27190-edb7-4cb8-88a9-ab73e8258b9a.png">

After this, click the green/red icon on the bot list to move the bot in/out of the maintenance mode.

<img width="599" alt="image" src="https://user-images.githubusercontent.com/33935/189493316-1e6f1248-a627-4acc-aaf6-82eac02fc4f7.png">

## Running locally

In order to receive webhook calls from Telegram, you need a solution like ngrok. See `config/dev.local.exs.example` on
how to configure the ngrok host.

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit your ngrok URL from your browser.

## Deployment

Ready to run in production? See our [deployment guide](DEPLOYMENT.md).

---

Copyright (c) 2022 Max Gorin, released under MIT
