FROM debian:wheezy
RUN apt-get update -qq
RUN apt-get install wget -qqy
RUN apt-get autoremove

RUN groupadd -r postgres --gid=999 && useradd -r -g postgres --uid=999 postgres

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main wheezy 9.3" > /etc/apt/sources.list.d/pgdg.list

RUN gpg --keyserver keys.gnupg.net --recv-keys ACCC4CF8
RUN gpg --export --armor ACCC4CF8|apt-key add -

RUN apt-get install libpq-dev postgresql-9.3 postgresql-common postgresql-contrib-9.3 postgresql-client-9.3
RUN apt-get clean

RUN echo "/etc/init.d/postgresql start && exit 0" > /etc/rc.local

USER postgres
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.4/main/pg_hba.conf
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.4/main/postgresql.conf

EXPOSE 5432

VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

CMD ["/usr/lib/postgresql/9.4/bin/postgres", "-D", "/var/lib/postgresql/9.4/main", "-c", "config_file=/etc/postgresql/9.4/main/postgresql.conf"]