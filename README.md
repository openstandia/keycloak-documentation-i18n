Keycloak Documentation translation project
======================

[![Crowdin](https://d322cqt584bo4o.cloudfront.net/keycloak-documentation-i18n/localized.svg)](https://crowdin.com/project/keycloak-documentation-i18n)
[![CircleCI](https://circleci.com/gh/openstandia/keycloak-documentation-i18n.svg?style=svg)](https://circleci.com/gh/openstandia/keycloak-documentation-i18n)

Support Languages
-------------------------------
Support languages are as follows. If you can help to translate to other language, [please create a issue](https://github.com/openstandia/keycloak-documentation-i18n/issues/new).

* Japanese (ja_JP)

Building Translated Keycloak Documentation
-------------------------------

Ensure that you have [Maven installed](https://maven.apache.org/) and [Docker installed](https://www.docker.com/docker-community).

First, clone this repository:

    git clone https://github.com/openstandia/keycloak-documentation-i18n.git
    cd keycloak-documentation-i18n

To build Translated Keycloak Documentation run:

    ./build-translation.sh

You can then view the documentation by opening translated/dist/{LANG}/index.html.

License
-------

* [Apache License, Version 2.0](https://www.apache.org/licenses/LICENSE-2.0)

