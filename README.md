# videom

### Docker stuff

##### 1. build images

    docker build -t videom .

##### 2. push to dockerhub

    docker login --user=username
    docker images
    docker tag imageId username/videom:latest
    docker push username/videom   

##### 3. pull from dockerhub

    docker pull username/videom

##### 4. run

    docker run -p 3000:3000 -v ~/videos:/root/videom/public/uploads -d username/videom
