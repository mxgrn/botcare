# Deployment

## Preparing for deployment

The following preparations proved to be enough to deploy the app with Docker on Digital Ocean. Your milage may vary, and
it's not a requirement to have a multi-instance setup, everything may as well run on a single instance.

That said, below is a 2-instance setup with 1) LB/DB host that would handle load balancing and DB, and 2) app host. More
app hosts can be added for redundancy once needed.

### Database

SSH to the LBDB host.

    # su postgres
    # psql

Create role `botcare_prod`:

    create role botcare_prod password '<password>';
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
          server <host-1-IP>:8030;
          # might be added later for redundant app hosts
          # server <host-2-IP>:8030;
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

  * SSH to the LBDB host
  * Run `certbot --nginx`
  * Follow instructions

## List of required runtime ENV vars

This ENV vars are expected to be set by the Docker container, and are usually configured via Github secrets:

* SECRET_KEY_BASE - Phoenix endpoint `secret_key_base` option
* DATABASE_URL - Postgres auth URI to connect to the DB
* BASIC_AUTH_USERNAME, BASIC_AUTH_PASSWORD - credentials for basic auth to login to the app
* CLOAK_KEY - encryption key used to encrypt bot tokens
* PHX_HOST - full name of the host that will be used with this app
* TELEGRAM_WEBHOOK_SECRET - [secret_token](https://core.telegram.org/bots/api#setwebhook) to guarantee that nobody can call your endpoints besides your bots
