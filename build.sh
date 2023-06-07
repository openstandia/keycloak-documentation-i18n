#!/bin/bash

DIR=$(cd $(dirname $0); pwd)
cd $DIR

CHANGE_FILES=`echo $1 | tr ',' '\n'`

echo "Change Files"
echo "---------------"
echo $CHANGE_FILES
echo "---------------"

if [[ "$CHANGE_FILES" = "" ]]; then
  echo "No build"
  exit 0
fi

BUILD_DIR=$DIR/build
DIST_DIR=$DIR/dist

echo "Clean $DIST_DIR"
rm -rf $DIST_DIR
mkdir -p $DIST_DIR

echo "Clean $BUILD_DIR"
rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR

echo "Clone keycloak-documentation"
git clone https://github.com/keycloak/keycloak-documentation $BUILD_DIR
cd $BUILD_DIR

for language in `ls $DIR/translations`; do
  # Check the target language files is changed
  echo $CHANGE_FILES | grep -q translations/$language

  if [[ $? -eq 0 ]]; then
    for version in `ls $DIR/translations/$language`; do
      # Check the target version files is changed
      echo $CHANGE_FILES | grep -q translations/$language/$version

      if [[ $? -eq 0 ]]; then
        TAG=`git tag --list "${version}" | sort | tail -n 1`
        if [ -z "$TAG" ]; then
          TAG=`git tag --list "${version}.*" | sort | tail -n 1`
        fi

        echo "Checkout $version"

        git reset --hard && git clean -xf
        git checkout $version

        if [[ $? -ne 0 ]]; then
          echo "Failed to checkout: version=$version, tag=$TAG"
          exit 1
        fi

        for pofile in `ls $DIR/src/$version`; do
          docname=`echo $pofile | sed "s/\.po//"`
          TARGET=$docname/index.adoc

          echo "Build $language/$version/$docname"

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
            -a po-directory=$DIR/translations/$language/$version/ \
            -a toc-title=目次 \
            -a nofooter=true \
            -a project_doc_base_url=link:.. \
            $TARGET

          if [[ $? -ne 0 ]]; then
            echo "Failed to build: $language/$version/$docname"
            exit 1
          fi

          DOC_VERSION_DIR=$DIST_DIR/$version
          DOC_DIST_DIR=$DOC_VERSION_DIR/$language/$docname
          echo "Copy resources to $DOC_DIST_DIR"

          mkdir -p $DOC_DIST_DIR

          cp $docname/index.html $DOC_DIST_DIR/

          if [ -d $docname/images ]; then
            cp -r $docname/images $DOC_DIST_DIR/
          fi

          if [ -d $docname/keycloak-images ]; then
            cp -r $docname/keycloak-images $DOC_DIST_DIR/
          fi

          sed -e "s|@VERSION@|$version|g" $DIR/site/index.html.tmpl > $DOC_VERSION_DIR/index.html
          cp $DIR/site/*.png $DOC_VERSION_DIR/
        done
      fi
    done
  fi
done

