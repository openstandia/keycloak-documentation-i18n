#!/bin/bash

SOURCE_REPO=https://github.com/keycloak/keycloak-documentation.git
SOURCE_REVISION=ee43080330c6d51ce6e9e94616b23de93c3e01c8
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
  release_notes \
  topics"

TARGET_EXT=adoc
OUT_FILE=po4a.cfg
IGNORE_FILE=topics.adoc
FORCE_TEXT_FILE="topics/templates/document-attributes-community.adoc|topics/templates/document-attributes-product.adoc"

