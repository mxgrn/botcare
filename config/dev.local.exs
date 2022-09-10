import Config

config :botcare, BotcareWeb.Endpoint, url: [host: "botcare.ngrok.io"]

System.put_env("TELEGRAM_WEBHOOK_SECRET", "StXuzKARHjcdVvwcjWME")
