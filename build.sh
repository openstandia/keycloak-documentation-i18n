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

BUILD_DIR1=$DIR/build1
BUILD_DIR2=$DIR/build2
DIST_DIR=$DIR/dist

echo "Clean $DIST_DIR"
rm -rf $DIST_DIR
mkdir -p $DIST_DIR

echo "Clean $BUILD_DIR1"
rm -rf $BUILD_DIR1
mkdir -p $BUILD_DIR1

echo "Clean $BUILD_DIR2"
rm -rf $BUILD_DIR2
mkdir -p $BUILD_DIR2

echo "Clone keycloak-documentation (old repository)"
git clone https://github.com/keycloak/keycloak-documentation $BUILD_DIR1

echo "Clone keycloak"
git clone https://github.com/keycloak/keycloak $BUILD_DIR2

for language in `ls $DIR/translations`; do
  # Check the target language files is changed
  echo $CHANGE_FILES | grep -q translations/$language

  if [[ $? -eq 0 ]]; then
    for version in `ls $DIR/translations/$language`; do
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

      # Check the target version files is changed
      echo $CHANGE_FILES | grep -q translations/$language/$version

      if [[ $? -eq 0 ]]; then
        TAG=`git tag --list "${version}" | sort | tail -n 1`
        if [ -z "$TAG" ]; then
          TAG=`git tag --list "${version}.*" | sort | tail -n 1`
        fi

        echo "Checkout $version ($TAG)"

        git reset --hard && git clean -xf
        git checkout $TAG

        if [[ $? -ne 0 ]]; then
          echo "Failed to checkout: $version ($TAG)"
          exit 1
        fi

        for pofile in `ls $DIR/src/$version`; do
          docname=`echo $pofile | sed "s/\.po//"`

          if [[ "$pofile" = "getting-started" -o "$pofile" = "migration" -o "$pofile" = "operator" -o "$pofile" = "server" ]]; then
            continue
          fi

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

