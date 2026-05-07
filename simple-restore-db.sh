#!/bin/bash

# --- CONFIGURAÇÕES ---
DB_HOST="127.0.0.1"
DB_NAME="banco"
DB_USER="usuario" # O usuário que tem permissão no banco
DB_PASS="senha"
BACKUP_DIR="/home/ubuntu/backup-db"

# --- VERIFICAÇÃO ---
# Verifica se o usuário passou o nome do arquivo como argumento
if [ -z "$1" ]; then
    echo "Uso: $0 nome_do_arquivo.sql.gz"
    echo "Arquivos disponíveis em $BACKUP_DIR:"
    ls -lh "$BACKUP_DIR" | grep ".gz"
    exit 1
fi

FILE_PATH="$BACKUP_DIR/$1"

# Verifica se o arquivo realmente existe
if [ ! -f "$FILE_PATH" ]; then
    echo "Erro: Arquivo $FILE_PATH não encontrado!"
    exit 1
fi

echo "Iniciando restauração da base '$DB_NAME' a partir de: $1..."

# O uso da variável MYSQL_PWD evita o alerta de senha na linha de comando
export MYSQL_PWD=$DB_PASS

# Executa a restauração:
# 1. zcat lê o arquivo compactado
# 2. mysql executa os comandos SQL
zcat "$FILE_PATH" | mysql -h "$DB_HOST" -u "$DB_USER" "$DB_NAME"

# Verifica se a restauração foi bem-sucedida
if [ $? -eq 0 ]; then
    echo "------------------------------------------"
    echo "Sucesso: Backup restaurado com sucesso!"
    echo "------------------------------------------"
else
    echo "------------------------------------------"
    echo "ERRO: Falha ao restaurar o backup."
    echo "------------------------------------------"
    exit 1
fi
