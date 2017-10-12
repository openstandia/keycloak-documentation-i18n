FROM fedora:rawhide

RUN yum install -y maven zip awscli git
RUN yum install -y po4a
RUN yum install -y perl-Unicode-LineBreak

