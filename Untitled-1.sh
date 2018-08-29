#!/bin/bash


reponame="$1"
tags=`wget -q https://registry.hub.docker.com/v1/repositories/${image}/tags -O -  | sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' | tr '}' '\n'  | awk -F: '{print $3}' > test-tags`
source_registry="docker.io/library/"
destination_registry="docker-registry-default.apps.example.com/openshift/"


while read -r line || [[ -n "$line" ]]; do
    echo "Start to pull/tag/push/rmi the image: $reponame:$line"

    docker pull "$source_registry$reponame:$line"

    docker tag "$source_registry$reponame:$line" "$destination_registry$reponame:$line"

    docker push "$destination_registry$reponame:$line"

done < "$tags"