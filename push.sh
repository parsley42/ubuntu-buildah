#!/bin/bash

. image-name.sh

if [ "$1" ]
then
    IMAGE="$1/$NAME"
elif [ "$REG_ORG" ]
then
    IMAGE="$REG_ORG/$NAME"
else
    echo "registry/org not provided or set in REG_ORG"
    echo "Usage: ./build.sh (registry/org)"
    exit 1
fi

echo "Pushing $IMAGE"

docker push $IMAGE
