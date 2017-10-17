Keycloak Documentation translation project
======================

[![CircleCI](https://circleci.com/gh/openstandia/keycloak-documentation-i18n.svg?style=svg)](https://circleci.com/gh/openstandia/keycloak-documentation-i18n)

Support Languages
-------------------------------
Support languages are as follows.

* Japanese (ja_JP)

Contributing
-------------------------------
Please see [CONTRIBUTING.md](./CONTRIBUTING.md)

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

