FROM kadock/s6:latest

RUN true \
    && apk --no-cache add ca-certificates tzdata \
    && apk --no-cache add cyrus-sasl cyrus-sasl-plain cyrus-sasl-login \
    && apk --no-cache add postfix \
    && apk --no-cache add postfix-pcre \
    && apk --no-cache add db-utils

ARG SASLDB_DIR=/var/lib/sasl2
COPY ./sasl2/smtpd.conf /etc/sasl2/
COPY ./bin/saslconf ./bin/sasluser /usr/sbin/
RUN true \
    && chmod +x /usr/sbin/saslconf \
    && chmod +x /usr/sbin/sasluser \
    && mkdir -p ${SASLDB_DIR}

COPY ./filters/command.pcre /etc/postfix/filters/
COPY ./maps/sender_login.pcre /etc/postfix/maps/

ARG SSL_DIR=/etc/postfix/ssl
RUN true \
    && mkdir -p ${SSL_DIR} \
    && postconf -e maillog_file=/dev/stdout \
    && postconf -e smtpd_delay_reject=yes \
    && postconf -e smtpd_helo_required=no \
    && postconf -M# smtp/inet \
    && postconf -M submission/inet="submission   inet   n   -   n   -   -   smtpd" \
    && postconf -e smtpd_command_filter=pcre:/etc/postfix/filters/command.pcre \
    && postconf -e notify_classes=resource,software,bounce \
    && postconf -e smtpd_sender_login_maps=pcre:/etc/postfix/maps/sender_login.pcre \
    && postconf -e smtpd_sasl_auth_enable=yes \
    && postconf -e smtpd_relay_restrictions=permit_sasl_authenticated,reject \
    && postconf -e smtpd_sender_restrictions=reject_sender_login_mismatch,permit_sasl_authenticated,reject \
    && postconf -e smtpd_recipient_restrictions=permit_sasl_authenticated,reject \
    && postconf -e disable_vrfy_command=yes \
    && postconf -e smtpd_tls_cert_file=${SSL_DIR}/server.pem \
    && postconf -e smtpd_tls_key_file=${SSL_DIR}/server.key \
    && postconf -e smtp_tls_security_level=may \
    && postconf -e smtpd_tls_security_level=may \
    && postconf -e smtp_tls_note_starttls_offer=yes \
    && postconf -e smtpd_tls_loglevel=1 \
    && postconf -e smtpd_tls_received_header=yes \
    && newaliases -f /etc/postfix/aliases 

RUN apk --no-cache add openssh-client
RUN mkdir -p /var/lib/certmgr
RUN mkdir -p /etc/certmgr
COPY ./certmgr/get_all ./certmgr/get_last /usr/share/certmgr/
COPY ./bin/renewcert /usr/sbin/renewcert
RUN chmod +x /usr/sbin/renewcert
RUN printf "*/1\t*\t*\t*\t*\t /usr/sbin/renewcert reload\n" > /etc/crontabs/root

COPY ./s6/fix-attrs.d/01-sasl2-db-dir ./s6/fix-attrs.d/02-certmgr-etc-dir /etc/fix-attrs.d/
COPY ./s6/cont-init.d/01-sasl2-db-create ./s6/cont-init.d/02-postconf-setup ./s6/cont-init.d/03-cert-renew /etc/cont-init.d/
COPY ./s6/services.d/crond /etc/services.d/crond

CMD ["/usr/sbin/postfix", "-c", "/etc/postfix", "start-fg"]
