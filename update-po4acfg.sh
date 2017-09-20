#!/bin/bash

DIR=$(cd $(dirname $0); pwd)
. $DIR/settings.sh
cd $DIR

REPO_DIR=$DIR/$SOURCE_DIR
OUT_FILE=$DIR/$OUT_FILE

# Clone
git clone --depth=1 $SOURCE_REPO $REPO_DIR
cd $REPO_DIR && git checkout $SOURCE_REVISION

# Generate base config
cat << EOS > $OUT_FILE
# Don't edit this file directly!
[po4a_langs] $TARGET_LANG
[po4a_paths] i18n/pot/\$master.pot \$lang:i18n/po/\$lang/\$master.\$lang.po

# [po4a_alias:myadoc] asciidoc opt:"-k 0 -M utf-8 -L utf-8"
# Workaround for handling asciidoc table and so on
[po4a_alias:myadoc] text opt:"-k 0 -M utf-8 -L utf-8 -o asciidoc -o neverwrap"

EOS

# Generate config per document
cd $REPO_DIR
for doc in $DOCS; do
    echo "# $doc" >> $OUT_FILE

    for file in `\find $doc -name "*.$TARGET_EXT" -not -name "index.$TARGET_EXT"`; do
        if [[ "$file" =~ /${IGNORE_FILE}$ ]]; then
            echo "Ignore: $file"
            continue
        fi

        # Checking the size because po4a can't handle 0 byte file
        if [[ ! -s "$file" ]]; then
            echo "Skipped (0 byte): $file"
            continue
        fi

        MASTER_FILE=`echo $file | sed -e "s|^$DIR||"`
        OUT_MASTER_FILE=`echo $MASTER_FILE | sed -e "s|/|__|g" | sed -e "s|\.$TARGET_EXT$||"`
        echo "[type: myadoc] $SOURCE_DIR/$MASTER_FILE \$lang:$TRANSLATED_DIR/\$lang/$MASTER_FILE master:file=$OUT_MASTER_FILE" >> $OUT_FILE
        echo "Add: $file"
    done

    echo "" >> $OUT_FILE
done

