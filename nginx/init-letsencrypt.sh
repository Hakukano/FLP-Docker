#!/bin/bash

ERROR_INVALID_ARGUMENTS=1
ERROR_MISSING_BIN=2

if ! [ -x "$(command -v docker-compose)" ]; then
  echo 'Error: docker-compose is not installed.' >&2
  exit $ERROR_MISSING_BIN
fi

this="$0"
base_domain="$1"
rsa_key_size="$2"
data_path="$3"
email="$4"
staging="$5"

usage() {
  echo -e "${this} <base_domain> <rsa_key_size> <data_path> <email> <staging>"
  echo -e "\tbase_domain: e.g. example.com"
  echo -e "\trsa_key_size: e.g. 4096"
  echo -e "\tdata_path: base certbot volumes path"
  echo -e "\temail: Email"
  echo -e "\tstaging"
  echo -e "\t\t0: Not staging, do real stuff"
  echo -e "\t\t1: Just for test"
}

[[ $# -ne 5 ]] && usage && exit ${ERROR_INVALID_ARGUMENTS}

if [ -d "$data_path" ]; then
  read -p "Existing data found for $base_domain. Continue and replace existing certificate? (y/N) " decision
  if [ "$decision" != "Y" ] && [ "$decision" != "y" ]; then
    exit
  fi
fi


if [ ! -e "$data_path/conf/options-ssl-nginx.conf" ] || [ ! -e "$data_path/conf/ssl-dhparams.pem" ]; then
  echo "### Downloading recommended TLS parameters ..."
  mkdir -p "$data_path/conf"
  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf > "$data_path/conf/options-ssl-nginx.conf"
  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot/certbot/ssl-dhparams.pem > "$data_path/conf/ssl-dhparams.pem"
  echo
fi

echo "### Creating dummy certificate for $base_domain ..."
path="/etc/letsencrypt/live/$base_domain"
mkdir -p "$data_path/conf/live/$base_domain"
docker-compose run --rm --entrypoint "\
  openssl req -x509 -nodes -newkey rsa:$rsa_key_size -days 1\
    -keyout '$path/privkey.pem' \
    -out '$path/fullchain.pem' \
    -subj '/CN=localhost'" certbot
echo


echo "### Starting nginx ..."
docker-compose up --force-recreate -d nginx
echo

echo "### Deleting dummy certificate for $base_domain ..."
docker-compose run --rm --entrypoint "\
  rm -Rf /etc/letsencrypt/live/$base_domain && \
  rm -Rf /etc/letsencrypt/archive/$base_domain && \
  rm -Rf /etc/letsencrypt/renewal/$base_domain.conf" certbot
echo


echo "### Requesting Let's Encrypt certificate for $base_domain and *.$base_domain ..."
domain_args="-d $base_domain -d *.$base_domain"

# Select appropriate email arg
case "$email" in
  "") email_arg="--register-unsafely-without-email" ;;
  *) email_arg="--email $email" ;;
esac

# Enable staging mode if needed
if [ $staging != "0" ]; then staging_arg="--staging"; fi

docker-compose run --rm --entrypoint "\
  certbot certonly --webroot -w /var/www/certbot \
    $staging_arg \
    $email_arg \
    $domain_args \
    --rsa-key-size $rsa_key_size \
    --agree-tos \
    --force-renewal" certbot
echo

echo "### Reloading nginx ..."
docker-compose exec nginx nginx -s reload
