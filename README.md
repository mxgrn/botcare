# Botcare

## Preparing for deployment

The following preparations proved to be enough to run deployment via Docker on Digital Ocean.

This is a 2-host setup, with 1) LB/DB host, and 2) app host. More app hosts can be added for redundancy once needed.

### Database

SSH to the LBDB host.

    # su postgres
    # psql

Create role `botcare_prod`:

    create role botcare_prod password '***';
    alter user botcare_prod superuser;
    alter role botcare_prod with login;

Create DB:

    create database botcare_prod with owner = botcare_prod;

After this you'll be able to connect from the app host (probably on the same network) with:

    postgres://botcare_prod:<password>@<db-host-IP>:5432/botcare_prod

### Github secrets

`DEPLOYMENT_KEY` must be the private part of the key accepted by `.ssh/authorized_keys` of the user "deploy".

### Authenticating with ghcr.io

  * SSH to the app host
  * Run `docker login ghcr.io`, authenticate with GH username and PAT (personal access token) generated with
  write/read/delete:packeges scopes
  * Make sure that `docker pull ghcr.io/<your-GH-username>/botcare` works

### NGINX

  * SSH to LBDB host
  * Add /etc/nginx/sites-enabled/botcare-prod:

       ```
        upstream botcare-prod {
          server 10.135.0.4:8030;
        # might be added later for redundant app hosts
        # server 10.135.0.5:8031;
        }

        server {
          server_name botcare.mxgrn.com;

          location / {
            include proxy_params;
            proxy_pass http://botcare-prod;

            # The following two headers need to be set in order
            # to keep the websocket connection open. Otherwise you'll see
            # HTTP 400's being returned from websocket connections.
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
          }
        }
      ```

  * Restart nginx with `nginx -s reload`

### SSL

  * SSH to lbdb
  * Run certbot --nginx
  * Follow instructions

## Running locally

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
