# minio-scripts

Scripts and Docker configs for Min.io Deployments

This repo contains everything to deploy a Traefik v2 load balancer as well as two minio instances.

Traefik, once configured with your cloudflare information, will get SSL certificates for your minio instances.

# Running Minio and Traefik

To start everything you can run:

docker-compose up -d traefik2/docker-compose.yml minio1/docker-compose.yml minio2/docker.compose.yml

## Scripts folder

create-user.sh - This script will create users in your minio instance and save the access and secret keys to files in the directory where the script is ran.
