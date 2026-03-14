#!/bin/bash

STORAGE_ACCOUNT="mystorage11834"
CONTAINER="files"
ACCOUNT_KEY=$AZURE_STORAGE_KEY
LOGFILE="storage.log"

log_action() {
    echo "$(date) - $1" >> $LOGFILE
}

case $1 in

upload)
    az storage blob upload \
    --account-name $STORAGE_ACCOUNT \
    --account-key $ACCOUNT_KEY \
    --container-name $CONTAINER \
    --name $2 \
    --file $2

    log_action "Uploaded file $2"
;;

download)
    az storage blob download \
    --account-name $STORAGE_ACCOUNT \
    --account-key $ACCOUNT_KEY \
    --container-name $CONTAINER \
    --name $2 \
    --file $2

    log_action "Downloaded file $2"
;;

list)
    az storage blob list \
    --account-name $STORAGE_ACCOUNT \
    --account-key $ACCOUNT_KEY \
    --container-name $CONTAINER \
    --output table

    log_action "Listed files"
;;

delete)
    az storage blob delete \
    --account-name $STORAGE_ACCOUNT \
    --account-key $ACCOUNT_KEY \
    --container-name $CONTAINER \
    --name $2

    log_action "Deleted file $2"
;;

*)
    echo "Usage:"
    echo "./storage.sh upload filename"
    echo "./storage.sh download filename"
    echo "./storage.sh list"
    echo "./storage.sh delete filename"
;;

esac
