FROM fedora:rawhide

RUN yum install -y maven zip awscli git
RUN yum install -y gettext
RUN yum install -y perl-Module-Build perl-Locale-gettext perl-Text-WrapI18N perl-TermReadKey perl-Pod-Parser perl-SGMLSpm perl-Unicode-LineBreak docbook-style-xsl
RUN yum install -y libxslt

ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

RUN cd $HOME && git clone https://github.com/mquinson/po4a.git && cd po4a && git config --global user.email "po4a" && git checkout 1e6c31274c4c49a6dbefa33293de692b67970d68 && git revert 6828ed597003b6ed31bd6e3f1edb70e46f1d2817
RUN cd $HOME/po4a && perl Build.PL && ./Build && ./Build install

