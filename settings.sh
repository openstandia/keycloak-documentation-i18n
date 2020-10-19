#!/bin/bash

SOURCE_REPO=https://github.com/keycloak/keycloak-documentation.git
SOURCE_REVISION=792deeb78669bc62f2e868405496eba99f78097e
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

