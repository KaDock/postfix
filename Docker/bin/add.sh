#!/usr/bin/env sh
user=$2
domain=$1
echo "Domain: $domain"
echo "Username $user"
saslpasswd2 -c -f /etc/sasl2/db/sasldb2 -u ${domain} ${user}
