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

# nginx

## .env
```
IMAGE_TAG= # e.g. 14
LOG_MAX_SIZE= # e.g. 100m
PORT_HTTP=
PORT_HTTPS=
VOLUMES_BASE=
```

# wordpress

## .env
```
IMAGE_TAG_DB= # e.g. 5
DB_PASSWORD_ROOT=
LOG_MAX_SIZE= # e.g. 100m
VOLUMES_BASE_DB=
IMAGE_TAG= # e.g. 6
PORT=
VOLUMES_BASE=
```
