#!/bin/bash

DIR=$(cd $(dirname $0); pwd)
. $DIR/settings.sh
cd $DIR

OUT_FILE=$DIR/.tx/config

# Generate base tx config
cat << EOS > $OUT_FILE
# Don't edit this file directly!
[main]
host = https://www.transifex.com

EOS

# Setup tx config
for doc in $DOCS; do
    for file in `find $DIR/i18n/pot/$doc/ -type f -name "*.pot"`; do
        SOURCE_FILE=`echo $file | sed "s|${DIR}/||"`
        SOURCE_FILE_BASE=`echo $file | sed "s|^$DIR/i18n/pot/||"`
        TRANSLATION_FILE_BASE=`echo $SOURCE_FILE_BASE | sed "s|\.pot$|\.<lang>.po|"`
        RESOURCE_SLUG=`echo $SOURCE_FILE_BASE | sed "s|/|__|g" | sed "s|\.pot$||"`

        tx set --auto-local -r keycloak-documentation-i18n.${RESOURCE_SLUG} -s en -t PO -f $SOURCE_FILE "i18n/po/<lang>/${TRANSLATION_FILE_BASE}" --execute

    done
done
