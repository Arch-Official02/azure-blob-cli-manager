#!/bin/bash

RESOURCE_GROUP="cloud-storage-rg"
LOCATION="eastus"
STORAGE_ACCOUNT="cloudstorage$RANDOM"
CONTAINER="files"

echo "Creating Resource Group..."
az group create --name $RESOURCE_GROUP --location $LOCATION

echo "Creating Storage Account..."
az storage account create \
--name $STORAGE_ACCOUNT \
--resource-group $RESOURCE_GROUP \
--location $LOCATION \
--sku Standard_LRS \
--allow-blob-public-access true

echo "Creating Container..."

KEY=$(az storage account keys list \
--resource-group $RESOURCE_GROUP \
--account-name $STORAGE_ACCOUNT \
--query "[0].value" \
--output tsv)

az storage container create \
--account-name $STORAGE_ACCOUNT \
--account-key $KEY \
--name $CONTAINER \
--public-access blob

echo "Deployment Complete"
echo "Storage Account: $STORAGE_ACCOUNT"
