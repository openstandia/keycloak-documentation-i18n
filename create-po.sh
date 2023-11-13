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

BUILD_DIR1=$DIR/build1
BUILD_DIR2=$DIR/build2

mkdir -p $BUILD_DIR1
git clone https://github.com/keycloak/keycloak-documentation $BUILD_DIR1
cd $BUILD_DIR1
git fetch --tags

mkdir -p $BUILD_DIR2
git clone https://github.com/keycloak/keycloak $BUILD_DIR2
cd $BUILD_DIR2
git fetch --tags

for version in `ls $DIR/src`; do
  if [[ $version != $1 ]]; then
      echo "Skipping $version"
      continue
  fi

  # Resolve build dir by the target version
  if [[ $version == 1* ]]; then
      cd $BUILD_DIR1
      echo "Use old repository for $version"
  elif [[ "$(echo "$version < 21.1" | bc)" -eq 1 ]]; then
      cd $BUILD_DIR1
      echo "Use old repository for $version"
  else
      cd $BUILD_DIR2/docs/documentation
      echo "Use new repository for $version"
  fi

  TAG=`git tag --list "${version}" | sort | tail -n 1`
  if [ -z "$TAG" ]; then
    TAG=`git tag --list "${version}.*" | sort | tail -n 1`
  fi

  echo "Checkout $TAG"

  git reset --hard && git clean -xf
  git checkout $TAG

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

