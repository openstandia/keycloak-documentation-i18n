Keycloak Documentation translation project
======================

Support Languages
-------------------------------
Support languages are as follows.

| Lang           | Translated Site                                   |
| -------------- | ------------------------------------------------- |
|Japanese (ja_JP)|https://keycloak-documentation.openstandia.jp      |

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

    docker run --rm -w /build -v (pwd):/build openstandia/keycloak-documentation-i18n:asciidoctor /build/build.sh translations/{LANG}/{VERSION}

You can then view the documentation by opening dist/{VERSION}/index.html.

License
-------

* [Apache License, Version 2.0](https://www.apache.org/licenses/LICENSE-2.0)

