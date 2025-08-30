#!/bin/env bash

generate_ssl() {
  openssl req -x509 -sha256 -nodes -newkey rsa:2048 -days 365 -keyout localhost.key -out localhost.crt
}

generate_ssl
echo "Make sure the localhost.key and localhost.crt are in the 'docker/nginx/certs' directory."

