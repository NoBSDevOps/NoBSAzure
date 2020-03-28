mkdir C:\docker
cd C:\docker
docker build
docker image ls webapp
docker run -d webapp:latest /bin/bash
