#!/usr/bash

# $1 is the repo name 
# $2 is the tag
# $3 is the servie name service container starts
 
docker_pull="sudo docker pull $1:$2"
docker_stop="sudo docker stop $3"
docker_rm="sudo docker rm nodeapp"
docker_run="sudo docker run -p 8080:8080 -d --name $3 $1:$2"
docker_login=$(sudo aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin 374590584164.dkr.ecr.us-east-1.amazonaws.com)

# Do a docker pull
echo "Doing a docker pull for the given repo"
res=`$docker_pull`
if [ $? != 0 ]; then
      exit 1
fi

# if you dont find the name of the container create it otherwise rm and create
if [ ! "$(sudo docker ps -q -f name=$3)" ]
then
    res=`$docker_run`
    echo "Executing docker run ...."
    if [ $? != 0 ]; then
           exit 1
    fi
else
    echo "Executing docker stop ...."
    res=`$docker_stop`
    if [ $? != 0 ]; then
	   exit 1
    fi
    sleep 5
    echo "Executing docker remove ..."
    res=`$docker_rm`
    if [ $? != 0 ]; then
           exit 1
    fi
    sleep 5
    echo "Executing docker run ...."
    res=`$docker_run`
    if [ $? != 0 ]; then
           exit 1
    fi

fi

