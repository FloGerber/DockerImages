# DockerImages

Docker Images for all kind of stuff

Remove old images without tag

```bash
docker rmi $(docker images -a | grep "^<none>" | awk '{print $3}')
```

Run an image for local development and testing with your current Project directory mounted

```bash
docker run --rm -v -ti <image_name:tag>
```

Build image without Caching and pull base new

```bash
docker build --no-cache --pull -f CloudMaturity.arm.Dockerfile -t cloudmaturity:latest .
```
