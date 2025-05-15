#!/bin/sh

# TODO replace with terraform (use Gitlab as terraform state backend)

### az setup
RESOURCE_GROUP=${RESOURCE_GROUP:-provisioning}
CURRENT_ENVIRONMENT=${CURRENT_ENVIRONMENT:-development}

echo "init-az.sh CURRENT_ENVIRONMENT:${CURRENT_ENVIRONMENT} RESOURCE_GROUP=${RESOURCE_GROUP}"

az login                                          \
  --service-principal                             \
  --username "${ARM_CLIENT_ID}"                   \
  --password "${ARM_CLIENT_SECRET}"               \
  --tenant "${ARM_TENANT_ID}"

GROUP_EXISTS=$(az group exists --name "${RESOURCE_GROUP}" --subscription "${ARM_SUBSCRIPTION_ID}")

if [ "$GROUP_EXISTS" = "false" ]; then
  az group create --name "${RESOURCE_GROUP}" --location "Germany West Central" --subscription "${ARM_SUBSCRIPTION_ID}"

  az storage account create                         \
    --name "${AZURE_STORAGE_ACCOUNT}"               \
    --resource-group "${RESOURCE_GROUP}"            \
    --location "${AZURE_STORAGE_ACCOUNT_LOCATION}"  \
    --subscription "${ARM_SUBSCRIPTION_ID}"         \
    --sku "Standard_LRS"

  az storage container create                       \
    --subscription "${ARM_SUBSCRIPTION_ID}"         \
    --account-name "${AZURE_STORAGE_ACCOUNT}"       \
    --resource-group "${RESOURCE_GROUP}"            \
    --name "workspaces"

  az storage container create                       \
    --subscription "${ARM_SUBSCRIPTION_ID}"         \
    --account-name "${AZURE_STORAGE_ACCOUNT}"       \
    --resource-group "${RESOURCE_GROUP}"            \
    --name "base"
else
  echo "Skipping creation of resource group ${RESOURCE_GROUP} and storage account as existant"
fi

## terraform
terraform init -reconfigure

if terraform workspace list | grep -L "${CURRENT_ENVIRONMENT}"; then
  terraform workspace new "${CURRENT_ENVIRONMENT}"
fi

terraform workspace select "${CURRENT_ENVIRONMENT}"

echo '####################################'
echo "###                              ###"
printf "###  %-15sEnvironment  ###\n" "${CURRENT_ENVIRONMENT}"
echo "###                              ###"
echo "####################################"