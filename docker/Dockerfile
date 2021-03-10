FROM debian:buster-slim

LABEL mantainer="Jeremías Casteglione <jeremias@talkingpts.org>"
LABEL version="2021.03.09"

USER root:root
WORKDIR /root

ENV USER root
ENV HOME /root

ADD ./utils/apt-*.sh /root/bin/
RUN chmod -v 0750 /root/bin /root/bin/*.sh

RUN /root/bin/apt-distupgrade.sh
RUN /root/bin/apt-install.sh bash ca-certificates wget locales less

ADD ./utils/uws-*.sh /root/bin/
RUN chmod -v 0750 /root/bin /root/bin/*.sh \
	&& install -m 0755 /root/bin/uws-login.sh /usr/local/bin/uws-login.sh

RUN echo 'en_US.UTF-8 UTF-8' >/etc/locale.gen \
	&& locale-gen \
	&& update-locale LANG=en_US.UTF-8

ARG UWS_UID=1000
ARG UWS_GID=1000

RUN groupadd -f -g ${UWS_GID} uws \
	&& useradd -o -d /home/uws -m -c 'uws' -g ${UWS_GID} -u ${UWS_UID} uws \
	&& chmod -v 0750 /home/uws

ENV UWSBOT aefcd0931bfaeab62fc421add4aea72db496b2ce933c88f5a05056995f931582
RUN wget -O uwsbot-devel.tgz http://jsbatch.uws.talkingpts.org/uwsbot/${UWSBOT}.tgz \
	&& echo "${UWSBOT}  uwsbot-devel.tgz" >checksum \
	&& sha256sum -c checksum \
	&& tar -C / --no-same-owner -vxzf uwsbot-devel.tgz \
	&& rm -vf uwsbot-devel.tgz checksum

RUN wget -O uwsbot-docs.txt http://jsbatch.uws.talkingpts.org/uwsbot/docs.txt \
	&& mkdir -vp /uws/share/doc/uwsbot \
	&& mv -vf uwsbot-docs.txt /uws/share/doc/uwsbot/docs.txt

RUN mkdir -vp /uws/share/uwsbot /uws/var/uwsbot/stats /home/uws/.config/uws/bot \
	&& chown -v uws:uws /uws/var/uwsbot/stats

VOLUME /uws/share/uwsbot
VOLUME /home/uws/.config/uws/bot

USER uws:uws
WORKDIR /home/uws

ENV USER uws
ENV HOME /home/uws

ARG UWS_UMASK=0027

RUN printf 'umask %s\n' ${UWS_UMASK} >>/home/uws/.profile
RUN printf "export PS1='%s '\n" '\u@\h:\W\$' >>/home/uws/.profile
RUN printf 'export PATH="%s:${PATH}"\n' '/uws/bin' >>/home/uws/.profile

CMD exec /usr/local/bin/uws-login.sh
