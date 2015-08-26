FROM debian:latest
MAINTAINER hugoliv <olivier.hugues@gmail.com>

# define environment varialbes for cron job
# field          allowed values
# -----          --------------
# minute         0-59
# hour           0-23
# day of month   1-31
# month          1-12 (or names, see below)
# day of week    0-7 (0 or 7 is Sun, or use names)


ENV 	CRON_MINUTE *	
ENV	CRON_HOUR *
ENV	CRON_DAY_M *
ENV	CRON_MONTH *
ENV	CRON_DAY_W *

ENV	CONF_PATH /etc/backup-manager

ENV 	DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
	cron \
	backup-manager \
	vim \ 
	&& apt-get clean \ 
	&& rm -rf /var/cache/apt/* /var/lib/apt/lists/*

RUN mkdir -p /etc/backup-manager/ && chmod 777 /etc/backup-manager

# add script that will be run by cron
ADD /backup-manager.sh /etc/backup-manager/backup-manager.sh

# add cron job
RUN echo "$CRON_MINUTE $CRON_HOUR $CRON_DAY_M $CRON_MONTH $CRON_DAY_W /etc/backup-manager/backup-manager.sh" \
	> cron && \
	crontab cron && \
	rm cron

RUN mv /etc/backup-manager.conf /etc/backup-manager/backup-manager.conf

# ADD backup-manager.conf /etc/backup-manager/backup-manager.conf

# RUN rm -rf /etc/backup-manager.conf

# tout va bien jusqu'ici

# RUN /usr/sbin/backup-manager -c /etc/backup-manager/backup-manager.conf

RUN touch /var/log/cron.log

# start process
CMD cron && tail -f /var/log/cron.log

VOLUME ["/etc/backup-manager", "/data"]


