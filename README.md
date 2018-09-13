# videom

### Docker stuff

* build images

    cd docker/api && docker build -t videom-api .
    cd docker/app && docker build -t videom-app .

* push to dockerhub

    docker login --user=username
    docker images
    docker tag imageId username/videom-api:latest   
    docker tag imageId username/videom-app:latest

    docker push username/videom-api   
    docker push username/videom-app   

* pull from dockerhub

    docker pull username/videom-api
    docker pull username/videom-app

* run

    docker run -p 3000:3000 -v ~/videos:/root/videom/public/uploads -d username/videom-api
    docker run -p 8000:8000 -d username/videom-api
