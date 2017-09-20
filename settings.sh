#!/bin/bash

SOURCE_REPO=https://github.com/keycloak/keycloak-documentation.git
SOURCE_REVISION=4cb5b9dd2daea2f61d372e39629b65013b21c57d
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
FORCE_TEXT_FILE="authorization_services/topics/policy/evaluation-api.adoc|topics/templates/document-attributes-community.adoc|topics/templates/document-attributes-product.adoc"

