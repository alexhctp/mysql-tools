#!/bin/bash

# --- CONFIGURAÇÕES ---
DB_HOST="127.0.0.1"
DB_NAME="database"
DB_USER="user" # Recomendo usar o nome do usuário, não a senha aqui
DB_PASS="minha_senha"
BACKUP_DIR="/home/ubuntu/backup-db"
DATE=$(date +%Y-%m-%d_%Hh%Mm)
FILENAME="${BACKUP_DIR}/backup_${DB_NAME}_${DATE}.sql.gz"

# Criar o diretório se não existir
mkdir -p "$BACKUP_DIR"

# Executar o backup usando gzip para economizar espaço
# O uso da variável MYSQL_PWD evita o alerta de senha na linha de comando
export MYSQL_PWD=$DB_PASS
mysqldump -h "$DB_HOST" -u "$DB_USER" "$DB_NAME" | gzip > "$FILENAME"

# Verificar se o backup foi criado com sucesso
if [ $? -eq 0 ]; then
  echo "Backup realizado com sucesso: $FILENAME"
  # Opcional: Remover backups com mais de 7 dias para não encher o disco
  find "$BACKUP_DIR" -type f -name "*.sql.gz" -mtime +7 -delete
else
  echo "Erro ao realizar o backup!"
  exit 1
fi
