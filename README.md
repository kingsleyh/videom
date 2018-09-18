# videom

### Docker stuff

* build images

    docker build -t videom .

* push to dockerhub

    docker login --user=username
    docker images
    docker tag imageId username/videom:latest   

    docker push username/videom   

* pull from dockerhub

    docker pull username/videom

* run

    docker run -p 3000:3000 -v ~/videos:/root/videom/public/uploads -d username/videom
