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
DIST_DIR=$DIR/dist

mkdir -p $DIST_DIR
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
        -a source-highlighter=coderay \
        -a imagesdir=./ \
        -a toc=left \
        -a icons=font \
        -a sectanchors=true \
        -a idprefix \
        -a idseparator=- \
        -a docinfo1=true \
        -a project_buildType=archive \
        -a language=$docname \
        -a po-directory=$DIR/translations/ja_JP/$version/ \
        -a toc-title=目次 \
        -a nofooter=true \
        -a project_doc_base_url=link:.. \
        $TARGET

      DOC_DIST_DIR=$DIST_DIR/$version/$docname
      echo "Copy resources to $DOC_DIST_DIR"

      mkdir -p $DOC_DIST_DIR
      rm -rf $DOC_DIST_DIR/*

      cp $docname/index.html $DOC_DIST_DIR/
      cp -r $docname/images $DOC_DIST_DIR/
      if [ -d $docname/keycloak-images ]; then
        cp -r $docname/keycloak-images $DOC_DIST_DIR/
      fi
    fi
  done
done

