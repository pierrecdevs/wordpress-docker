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

## Helpful Tips

Once you've initiated your WordPress and you're ready to build your theme in `app/wp-content/themes/customtheme` add the following snippets to a `functions.php` file

```php
<?php
define('CUSTOM_THEME_DIR_URI', get_template_directory_uri());
define('CUSTOM_THEME_DIR', get_template_directory());

// Composer Psr4
require_once(CUSTOM_THEME . '/vendor/autoload.php');
```

## Known Caveats

- Unable to write to `app/` 
  - You may not have write access to the `app/` folder, simply run a `chown $USER:USER -R app/` and that should fix the issues.
- `wp-config.php` couldn't be updated upon setup
  - This is fine, just copy and paste the config they give you into a new file named `wp-config`

