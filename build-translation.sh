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

# Merge all translated branches if need
if [[ "$CIRCLE_BRANCH" = translate-* ]]; then
    echo "Mergeing all translate-* branches temporary"
    BRANCHES=`git branch -r | tr -d ' ' | grep "^origin/translate\-*"` 
    git config user.email "preview@example.com"
    git config user.name "preview"
    for branch in $BRANCHES; do
        git merge -m "preview" $branch
        if [ "$?" -ne 0 ]; then
            git merge --abort
        fi
    done
fi

# Clone
git clone $SOURCE_REPO $REPO_DIR
cd $REPO_DIR && git checkout $SOURCE_REVISION
git reset --hard HEAD && git clean -f

# Preparation for building translated documents
for l in $TARGET_LANG; do
    mkdir -p $TRANSLATED_DIR/$l
    cp -rap $REPO_DIR/* $TRANSLATED_DIR/$l/

    # custom pom.xml
    # TODO: toc-title need to be translated for the lang
    sed -i -e "s|<attributes>|<attributes><toc-title>目次</toc-title><nofooter>true</nofooter>|" $TRANSLATED_DIR/$l/pom.xml

    # custom image
    cp $DIR/site/*.png $TRANSLATED_DIR/$l/aggregation/src/
done


# Apply *.po file
cd $DIR
type po4a
if [ "$?" -eq 0 ]; then
    po4a po4a.cfg
else
    docker run --rm -it -v $(pwd):/build -w /build -u $UID:$GID openstandia/keycloak-documentation-i18n:po4a-patch po4a --no-update --package-name="keycloak-documentation-i18n" --package-version=" " --copyright-holder="Nomura Research Institute, Ltd." --msgmerge-opt '--no-location --no-wrap --previous' po4a.cfg
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

