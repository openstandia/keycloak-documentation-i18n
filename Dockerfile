FROM fedora:rawhide

RUN yum install -y maven zip awscli git
RUN yum install -y rpm-build rpmdevtools yum-utils
RUN rpmdev-setuptree

ARG VERSION=1e6c31274c4c49a6dbefa33293de692b67970d68
ARG SRPM_VERSION=a990a3460a4cff4ea4f933339913ccf4c47963ca

RUN cd $HOME && git clone https://src.fedoraproject.org/cgit/rpms/po4a.git rpms-po4a && cd rpms-po4a && git config --global user.email "po4a" && git checkout $SRPM_VERSION
RUN cp $HOME/rpms-po4a/*.spec $HOME/rpmbuild/SPECS/

RUN cd $HOME && git clone https://github.com/mquinson/po4a.git po4a-$VERSION && cd po4a-$VERSION && git config --global user.email "po4a" && git checkout $VERSION && git revert 6828ed597003b6ed31bd6e3f1edb70e46f1d2817 && cd .. && tar --exclude-vcs -czf po4a-$VERSION.tar.gz po4a-$VERSION && mv po4a-$VERSION.tar.gz $HOME/rpmbuild/SOURCES/

RUN yum-builddep -y $HOME/rpmbuild/SPECS/po4a.spec

RUN sed -i -e "s|^Version: .*|Version: $VERSION|" $HOME/rpmbuild/SPECS/po4a.spec
RUN sed -i -e "s|^Source0: .*|Source0: https://github.com/mquinson/po4a/archive/%{name}-%{version}.tar.gz|" $HOME/rpmbuild/SPECS/po4a.spec
RUN sed -i -e "/^\.\/Build test$/d" $HOME/rpmbuild/SPECS/po4a.spec

ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

RUN rpmbuild -ba $HOME/rpmbuild/SPECS/po4a.spec


FROM fedora:rawhide

RUN yum install -y maven zip awscli git

ARG VERSION=1e6c31274c4c49a6dbefa33293de692b67970d68

COPY --from=0 /root/rpmbuild/RPMS/noarch/po4a-${VERSION}-1.fc28.noarch.rpm /tmp/

RUN yum install -y /tmp/*.rpm perl-Unicode-LineBreak

