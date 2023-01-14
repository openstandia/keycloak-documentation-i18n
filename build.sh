#!/bin/bash

DIR=$(cd $(dirname $0); pwd)
cd $DIR

VERSION=$1

for file in `ls source`; do
  TARGET=source/$file/index.adoc

  if [ -f $TARGET ]; then
    echo $file

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
      -a language=$file \
      -a po-directory=translations/ja_JP/$VERSION/ \
      -a toc-title=目次 \
      -a nofooter=true \
      $TARGET
  fi

done

