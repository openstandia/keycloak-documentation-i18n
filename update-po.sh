#!/bin/bash

DIR=$(cd $(dirname $0); pwd)
. $DIR/settings.sh
cd $DIR

REPO_DIR=$DIR/$SOURCE_DIR

# Clean all
mkdir -p $REPO_DIR

# Clone
git clone $SOURCE_REPO $REPO_DIR
cd $REPO_DIR && git checkout $SOURCE_REVISION
git reset --hard HEAD && git clean -f

# Update pot files
cd $DIR
type po4a
if [ "$?" -eq 0 ]; then
    po4a po4a.cfg
else
    docker run --rm -it -v $(pwd):/build -w /build -u $UID:$GID openstandia/keycloak-documentation-i18n:po4a-patch po4a --no-translations --package-name="keycloak-documentation-i18n" --package-version=" " --copyright-holder="Nomura Research Institute, Ltd." --msgmerge-opt '--previous' $@ po4a.cfg
fi

# Remove 'POT-Creation-Date'
find i18n/po/ -type f -name "*.po" | xargs sed -i -e "/^\"POT-Creation-Date/d"
find i18n/po/ -type f -name "*.po" | xargs sed -i -e "/^\"PO-Revision-Date/d"
find i18n/pot/ -type f -name "*.pot" | xargs sed -i -e "/^\"POT-Creation-Date/d"
find i18n/pot/ -type f -name "*.pot" | xargs sed -i -e "/^\"PO-Revision-Date/d"

