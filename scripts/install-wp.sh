#!/usr/bin/env bash
download_wp() {
  local version='6.8.2'
  curl -o wordpress.tar.gz -fL "https://wordpress.org/wordpress-$version.tar.gz"
}

verify_dl() {
  local sha1='03baad10b8f9a416a3e10b89010d811d9361e468'
  echo "$sha1 *wordpress.tar.gz" | sha1sum -c -; 
}

extract_wp() {
  tar -xzf wordpress.tar.gz -C .;
  rm wordpress.tar.gz;
  mv wordpress/ app/
}

download_wp
verify_dl
extract_wp
