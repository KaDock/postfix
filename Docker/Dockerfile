ARG ALPINE_VERSION=latest
FROM alpine:${ALPINE_VERSION}

RUN apk --no-cache add ca-certificates tzdata
RUN apk --no-cache add cyrus-sasl cyrus-sasl-plain cyrus-sasl-login
RUN apk --no-cache add postfix
RUN apk --no-cache add postfix-pcre
RUN apk --no-cache add db-utils

RUN postconf -e maillog_file=/dev/stdout
RUN postconf -e smtpd_delay_reject=yes
RUN postconf -e smtpd_helo_required=no
RUN postconf -M# smtp/inet
RUN postconf -M submission/inet="submission   inet   n   -   n   -   -   smtpd"
RUN mkdir -p /etc/postfix/filters
RUN mkdir -p /etc/postfix/maps
RUN mkdir -p /etc/postfix/ssl
RUN mkdir -p /etc/sasl2/db

COPY filters/command.pcre /etc/postfix/filters/command.pcre
RUN postconf -e smtpd_command_filter=pcre:/etc/postfix/filters/command.pcre
RUN postconf -e notify_classes=resource,software,bounce


COPY maps/sender_login.pcre /etc/postfix/maps/sender_login.pcre
RUN postconf -e smtpd_sender_login_maps=pcre:/etc/postfix/maps/sender_login.pcre
RUN postconf -e smtpd_sasl_auth_enable=yes
RUN postconf -e smtpd_relay_restrictions=permit_sasl_authenticated,reject
RUN postconf -e smtpd_sender_restrictions=reject_sender_login_mismatch,permit_sasl_authenticated,reject
RUN postconf -e smtpd_recipient_restrictions=permit_sasl_authenticated,reject
RUN postconf -e disable_vrfy_command=yes

COPY sasl2/smtpd.conf /etc/sasl2/smtpd.conf
COPY sasl2/emptydb /etc/sasl2/emptydb

COPY bin/run.sh /run.sh
RUN chmod +x /run.sh

COPY bin/add.sh /add.sh
RUN chmod +x /add.sh

COPY bin/load.sh /load.sh
RUN chmod +x /load.sh

COPY bin/dump.sh /dump.sh
RUN chmod +x /dump.sh

RUN newaliases -f /etc/postfix/aliases

RUN postconf -e smtpd_tls_cert_file=/etc/postfix/ssl/server.pem
RUN postconf -e smtpd_tls_key_file=/etc/postfix/ssl/server.key
RUN postconf -e smtp_tls_security_level=may
RUN postconf -e smtpd_tls_security_level=may
RUN postconf -e smtp_tls_note_starttls_offer=yes
RUN postconf -e smtpd_tls_loglevel=1
RUN postconf -e smtpd_tls_received_header=yes


CMD ["sh", "-c", "/run.sh"]
