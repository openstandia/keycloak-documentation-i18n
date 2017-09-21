#!/bin/bash

DIR=$(cd $(dirname $0); pwd)
. $DIR/settings.sh
cd $DIR

REPO_DIR=$DIR/$SOURCE_DIR
TRANSLATED_DIR=$DIR/$TRANSLATED_DIR

# Clean all
rm -rf $TRANSLATED_DIR/*
mkdir -p $REPO_DIR
mkdir -p $TRANSLATED_DIR

# Clone
git clone --depth=1 $SOURCE_REPO $REPO_DIR
cd $REPO_DIR && git checkout $SOURCE_REVISION
git reset --hard HEAD && git clean -f

# Preparation for building translated documents
SOURCE_DIRS=`find $REPO_DIR -maxdepth 1 -type d -not -name '.git' -not -name 'i18n' -not -name 'translated' -not -name '.'`
for l in $TARGET_LANG; do
    mkdir -p $TRANSLATED_DIR/$l
    for d in $SOURCE_DIRS; do
        cp -rap $d $TRANSLATED_DIR/$l/
    done
    cp -ap $REPO_DIR/pom.xml $TRANSLATED_DIR/$l/
done


# Apply *.po file
cd $DIR
type po4a
if [ "$?" -eq 0 ]; then
    po4a po4a.cfg
else
    docker run --rm -it -v $(pwd):/build -w /build -u $UID:$GID openstandia/keycloak-documentation po4a --no-update --package-name="keycloak-documentation-i18n" --package-version=" " --copyright-holder="Nomura Research Institute, Ltd." --msgmerge-opt '--no-location --no-wrap --previous' po4a.cfg
fi

if [ "$?" -ne 0 ]; then
    exit 1
fi


# Build translated documents
for l in $TARGET_LANG; do
    cd $TRANSLATED_DIR/$l
    mvn install -DskipTests=true
    if [ "$?" -ne 0 ]; then
        echo "Translation failed!"
        exit 1
    fi 
done


# Archive
for l in $TARGET_LANG; do
    mkdir -p $TRANSLATED_DIR/dist/$l
    cd $TRANSLATED_DIR/$l/target
    mv * $TRANSLATED_DIR/dist/$l
done
cd $TRANSLATED_DIR/dist
zip -r keycloak-documentation-i18n.zip .

