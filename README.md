# Docker WordPress

## Intro

Although there's an official package on Dockerhub, I wanted to create my own.
This helps with quick setups.

## Getting Started

Before starting the containers, there's little bit of setup that needs to happen.

1. Run `./scripts/init-certs.sh` to generate your self-signed SSL certs. Nginx will be running on port 8443 (you can change this, make sure to update `docker/nginx/conf.d/default.conf`)
2. Run `./scripts/install-wp.sh` to download fresh copy of WordPress
3. Make sure to copy the .env.example to .env (`cp .env.example .env`) and fill them out how you wish.
4. Start the containers. `docker compose up -d`
5. Verify everything is up `docker compose logs -f`.

Once you've done the five steps, you're good to walk through the WordPress setup. `https://localhost:8443/`
