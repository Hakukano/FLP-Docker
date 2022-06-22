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

## .env
```
IMAGE_TAG_NGINX= # e.g. 14
LOG_MAX_SIZE= # e.g. 100m
PORT_NGINX_HTTP=
PORT_NGINX_HTTPS=
VOLUMES_BASE_NGINX=
VOLUMES_BASE_CERTBOT=
```
