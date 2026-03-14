# Simple Cloud File Storage using Bash and Azure CLI

## Overview

This project implements a simple cloud-based file storage system similar to Dropbox or Google Drive using **Azure Blob Storage** and **Bash scripting**.

The system allows users to upload, download, list, and delete files from cloud storage using command-line tools.

Automation is also implemented using **GitHub Actions** to deploy the infrastructure automatically.

---

## Technologies Used

- Bash
- Azure CLI
- Azure Blob Storage
- GitHub Actions
Architecture
User
  |
  | Bash Script
  |
Azure CLI
  |
Azure Blob Storage
Features
- Upload files to cloud storage
- Download files from cloud storage
- List files in storage
- Delete files
- Logging system to record operations
- Automated deployment using Bash
- CI/CD automation using GitHub Actions
Prerequisites
- Azure Account
- Azure CLI installed
- Git installed

Install Azure CLI:

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

Login to Azure:

az login
Manual Deployment

Run the deployment script:

chmod +x deploy.sh
./deploy.sh

This script will:

Create a Resource Group

Create an Azure Storage Account

Create a Blob Container

Enable public access

Deployment Script (deploy.sh)
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
--kind StorageV2 \
--allow-blob-public-access true

echo "Getting Storage Key..."

KEY=$(az storage account keys list \
--resource-group $RESOURCE_GROUP \
--account-name $STORAGE_ACCOUNT \
--query "[0].value" \
--output tsv)

echo "Creating Container..."

az storage container create \
--account-name $STORAGE_ACCOUNT \
--account-key $KEY \
--name $CONTAINER \
--public-access blob

echo "Deployment completed"
echo "Storage Account: $STORAGE_ACCOUNT"
File Management Script (storage.sh)
#!/bin/bash

STORAGE_ACCOUNT="your-storage-name"
CONTAINER="files"
LOGFILE="storage.log"

log_action() {
    echo "$(date) - $1" >> $LOGFILE
}

case $1 in

upload)
    az storage blob upload \
    --account-name $STORAGE_ACCOUNT \
    --container-name $CONTAINER \
    --name $2 \
    --file $2

    log_action "Uploaded file $2"
;;

download)
    az storage blob download \
    --account-name $STORAGE_ACCOUNT \
    --container-name $CONTAINER \
    --name $2 \
    --file $2

    log_action "Downloaded file $2"
;;

list)
    az storage blob list \
    --account-name $STORAGE_ACCOUNT \
    --container-name $CONTAINER \
    --output table

    log_action "Listed files"
;;

delete)
    az storage blob delete \
    --account-name $STORAGE_ACCOUNT \
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
Logging System

All actions performed on the storage are recorded in:

storage.log

Example log entry:

Sat Mar 15 2026 - Uploaded file test.txt
GitHub Actions Automation

Folder structure:

.github/workflows/deploy.yml

Workflow file:

name: Deploy Azure Storage

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:

    - name: Checkout Repository
      uses: actions/checkout@v3

    - name: Azure Login
      uses: azure/login@v1
      with:
        creds: ${{ secrets.AZURE_CREDENTIALS }}

    - name: Run Deployment Script
      run: |
        chmod +x deploy.sh
        ./deploy.sh
Usage Examples

Upload file

./storage.sh upload test.txt

List files

./storage.sh list

Download file

./storage.sh download test.txt

Delete file

./storage.sh delete test.txt
Repository Structure
cloud-storage-project
│
├── deploy.sh
├── storage.sh
├── README.md
├── storage.log
└── .github
    └── workflows
        └── deploy.yml
Conclusion

This project demonstrates how to build a simple cloud-based file storage system using Bash scripting and Azure Blob Storage, with full automation using GitHub Actions.

1️⃣ **A more advanced `storage.sh` (with folder upload + error handling)**  
2️⃣ **How to generate the `AZURE_CREDENTIALS` secret for GitHub Actions** (most students get stuck here)  
3️⃣ **Exactly where to take screenshots for the report so you get full marks**.
