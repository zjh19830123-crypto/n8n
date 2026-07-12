ARG N8N_VERSION=latest

GENERIC_TIMEZONE=Asia/Shanghai

TZ=Asia/Shanghai

N8N_PORT=8080

N8N_PROXY_HOPS=1

DB_TYPE=postgresdb

N8N_EDITOR_BASE_URL=https://my-free-n8n.containers.snapdeploy.app/

WEBHOOK_URL=https://my-free-n8n.containers.snapdeploy.app/

DB_POSTGRESDB_HOST=aws-0-us-west-1.pooler.supabase.com

DB_POSTGRESDB_PORT=6543

DB_POSTGRESDB_DATABASE=postgres

DB_POSTGRESDB_USER=postgres.gbscpnyarulkiswlzmib

DB_POSTGRESDB_PASSWORD=n8n@Awf123456789A

N8N_ENCRYPTION_KEY=n8n

FROM docker.io/n8nio/n8n:${N8N_VERSION}

USER root
