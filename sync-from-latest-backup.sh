#!/bin/bash

set -e
set -x


if [ -d "backup" ]; then
  echo "Backup folder already exists. Remove it first"
  exit 1
fi

if [ -d "html/sites/default/files" -o -d "private" ]; then
  echo "'html/sites/default/files' and 'private' will be overwritten - remove them"
  exit 1
fi

if [ ! -d "html/sites/default" ]; then
  echo "'html/sites/default' does not exist - try 'make' first"
  exit 1
if

MYSQL_PORT=`docker inspect ddev-yeebo-phoenix-db | jq -r '.[0].NetworkSettings.Ports."3306/tcp"[0].HostPort'`

if [ "null" == "${MYSQL_PORT}" ]; then
  echo "Unable to get mysql port number. Try \`ddev start\`"
  exit 1
fi

LATEST_VERSION=`ssh ec2-user@yeebo.org "ls -t /mnt/data/yeebo-backups | head -n1"`

if [ "x${LATEST_VERSION}" = "x" ]; then
  echo "Unable to get details of latest backup. Is server accessible?"
  exit 1
fi

echo "Restoring from backup file ${LATEST_VERSION}"

mkdir backup

echo "Fetching user content (files, private)"
ssh ec2-user@yeebo.org "cat /mnt/data/yeebo-backups/${LATEST_VERSION} | tar -xOzf - filecontent.tar" | tar xpvf - -C backup ./html/sites/default/files ./private

echo "Restoring database"
ssh ec2-user@yeebo.org "cat /mnt/data/yeebo-backups/${LATEST_VERSION} | tar -xOzf - dbcontent.sql" | mysql -u db -pdb db -h 127.0.0.1 --port ${MYSQL_PORT}

mv backup/html/sites/default/files html/sites/default
mv backup/private private
rmdir backup
