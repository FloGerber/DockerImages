# OpenTofu

OpenTofu Docker image containing OpenTofu and Terraspace as a Framework and the Azurecli for managing azure tenants.

## Build

```
sudo docker build -t opentofu:latest .
```

Rebuild without caching to get the latest base image

```
sudo docker build --no-cache -t opentofu:latest .