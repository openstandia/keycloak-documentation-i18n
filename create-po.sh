#!/bin/bash

DIR=$(cd $(dirname $0); pwd)
cd $DIR

VERSION=$1

mkdir -p src/$VERSION

for file in `ls source`; do
  TARGET=source/$file/index.adoc

  if [ -f $TARGET ]; then 
    echo $file

    asciidoctor -r asciidoctor-i18n -a language=${file} -a po-directory=./src/$VERSION $TARGET
  fi

done

