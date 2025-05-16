# DockerImages
Docker Images for all kind of stuff


Remove old images without tag 

```
docker rmi $(docker images -a | grep "^<none>" | awk '{print $3}')
```
