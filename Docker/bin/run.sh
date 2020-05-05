#!/usr/bin/env sh
postconf -e mydomain=${DM_DOMAIN}
postconf -e myhostname=${DM_HOSTNAME}
postconf -e bounce_notice_recipient=${DM_BOUNCE}

SASLDB=/etc/sasl2/db/sasldb2

if [[ ! -f "${SASLDB}" ]]
then
	db_load -f /etc/sasl2/emptydb ${SASLDB}
else
	echo "Exists"
fi
chown :postfix ${SASLDB}
chmod g+r ${SASLDB}

/usr/sbin/postfix -c /etc/postfix start-fg
