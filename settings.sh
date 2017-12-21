#!/bin/bash

SOURCE_REPO=https://github.com/keycloak/keycloak-documentation.git
# 3.4.1.Final
SOURCE_REVISION=1bd6fa62d74b5aeaec5cde01429719700dfc4cde
SOURCE_DIR=source
TRANSLATED_DIR=translated
TARGET_LANG=ja_JP
DOCS="\
  getting_started \
  server_installation \
  securing_apps \
  server_admin \
  server_development \
  authorization_services \
  upgrading \
  topics"

TARGET_EXT=adoc
OUT_FILE=po4a.cfg
IGNORE_FILE=topics.adoc
FORCE_TEXT_FILE="topics/templates/document-attributes-community.adoc|topics/templates/document-attributes-product.adoc"

