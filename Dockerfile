FROM debian:latest
MAINTAINER Stéphane DI RAIMONDO

RUN apt-get update && apt-get install -y git wget build-essential openssl expat libssl-dev libxml-parser-perl libcam-pdf-perl && \
    apt-get clean
RUN wget --no-check-certificate -O - http://install.perlbrew.pl | bash
RUN ~/perl5/perlbrew/bin/perlbrew init
RUN ~/perl5/perlbrew/bin/perlbrew --force install -n `~/perl5/perlbrew/bin/perlbrew available | head -1` --as webkeepass -j 3
RUN ~/perl5/perlbrew/bin/perlbrew use webkeepass
RUN wget --no-check-certificate -O - https://raw.github.com/miyagawa/cpanminus/master/cpanm > /opt/cpanm
RUN chmod +x /opt/cpanm
RUN ln -s /opt/cpanm /usr/bin/
RUN mkdir -p /srv/webkeepass
RUN cd /srv/webkeepass
RUN env GIT_SSL_NO_VERIFY=true git clone https://github.com/sukria/WebKeePass.git /srv/webkeepass
RUN cpanm Dist::Zilla
RUN cpanm XML::Parser
RUN cpanm Dancer2
RUN cpanm Digest::SHA1
RUN cd /srv/webkeepass; dzil authordeps | cpanm -nq && dzil listdeps | cpanm -nq
RUN rm /srv/webkeepass/bin/app.pl
ADD app.pl /srv/webkeepass/bin/
RUN chmod +x /srv/webkeepass/bin/app.pl
ADD production.yml /srv/webkeepass/environments/
RUN rm /srv/webkeepass/lib/WebKeePass.pm
ADD WebKeePass.pm /srv/webkeepass/lib/

RUN mkdir /keepass

ADD start.sh /
RUN chmod +x /start.sh

VOLUME /keepass

EXPOSE 5001
