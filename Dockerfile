FROM centos:7
LABEL maintainer="Tobias Florek <tob@butter.sh>"

VOLUME /var/run/rspamd
VOLUME /var/lib/rspamd
VOLUME /var/lib/rspamd/dkim
VOLUME /etc/rspamd/local.d
VOLUME /etc/rspamd/override.d

ENV RSPAMD_REPO_URL=https://rspamd.com/rpm-stable/centos-7/rspamd.repo

RUN curl -sSL $RSPAMD_REPO_URL | sed s/http:/https:/ > /etc/yum.repos.d/rspamd.repo \
 && yum install -y epel-release \
 && yum install -y rspamd \
 && yum clean all \
 && sed -i '/ type = /s/file/console/' /etc/rspamd/rspamd.conf \
 && test $(id -u _rspamd) = 999

USER 999
ENTRYPOINT ["/usr/bin/rspamd", "-f"]
CMD ["-c", "/etc/rspamd/rspamd.conf"]
