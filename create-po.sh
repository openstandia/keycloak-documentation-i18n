#!/bin/bash

DIR=$(cd $(dirname $0); pwd)
cd $DIR

DOCS="\
  server_installation \
  securing_apps \
  server_admin \
  server_development \
  authorization_services \
  upgrading \
  release_notes"

BUILD_DIR=$DIR/build

mkdir -p $BUILD_DIR
git clone https://github.com/keycloak/keycloak-documentation $BUILD_DIR
cd $BUILD_DIR

for version in `ls $DIR/src`; do
  echo "Checkout $version"

  git reset --hard && git clean -xf
  git checkout $version

  for docname in $DOCS; do
    TARGET=$docname/index.adoc

    if [ -f $TARGET ]; then
      echo "Build $docname"

      asciidoctor \
        -b html5 \
        -r asciidoctor-i18n \
        -a project_buildType=archive \
        -a language=$docname \
        -a po-directory=$DIR/src/$version/ \
        $TARGET
    fi
  done
done

