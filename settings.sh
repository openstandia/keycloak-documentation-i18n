#!/bin/bash

SOURCE_REPO=https://github.com/keycloak/keycloak-documentation.git
SOURCE_REVISION=4cb5b9dd2daea2f61d372e39629b65013b21c57d
SOURCE_DIR=source
TRANSLATED_DIR=translated
TARGET_LANG=ja_JP
DOCS="\
  server_installation \
  topics"

DOCS2="\
  getting_started \
  securing_apps \
  server_admin \
  server_development \
  authorization_services \
  upgrading"

TARGET_EXT=adoc
OUT_FILE=po4a.cfg
IGNORE_FILE=topics.adoc
FORCE_TEXT_FILE="x509.adoc|fuse-admin.adoc|authorization_services/.*|topics/templates/document-attributes-community.adoc|topics/templates/document-attributes-product.adoc"

