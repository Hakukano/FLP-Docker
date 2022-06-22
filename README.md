# FLP-Docker
Common docker(-compose) files

# postgres

## .env
```
IMAGE_TAG= # e.g. 14
PASSWORD=
LOG_MAX_SIZE= # e.g. 100m
PORT=
VOLUMES_BASE=
```

# nginx\_certbot
1. Run confgen to generate nginx configuration
1. Run init-letsencrypt.sh for first time setup

## .env
```
IMAGE_TAG_NGINX= # e.g. 14
LOG_MAX_SIZE= # e.g. 100m
PORT_NGINX_HTTP=
PORT_NGINX_HTTPS=
VOLUMES_BASE_NGINX=
VOLUMES_BASE_CERTBOT=
```
