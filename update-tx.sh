#!/bin/bash

DIR=$(cd $(dirname $0); pwd)
. $DIR/settings.sh
cd $DIR

target=`git diff --name-only $1 | grep i18n/pot/`

echo $target

if [[ $target = "" ]]; then
    echo "Nothing to do"
    exit
fi

for file in $target; do
    SOURCE_FILE_BASE=`echo $file | sed "s|^i18n/pot/||"`
    RESOURCE_SLUG=`echo $SOURCE_FILE_BASE | sed "s|/|__|g" | sed "s|\.pot$||"`

    echo $RESOURCE_SLUG

    tx push -s -r keycloak-documentation-i18n.$RESOURCE_SLUG
done


