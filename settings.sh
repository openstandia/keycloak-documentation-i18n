#!/bin/bash

SOURCE_REPO=https://github.com/keycloak/keycloak-documentation.git
# 3.4.1.CR1 
SOURCE_REVISION=cb1948b6a41d1fedcad8917bb0c1b26a251f2ad2
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

