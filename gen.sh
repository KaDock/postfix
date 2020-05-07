#!/usr/bin/env sh

# render a template configuration file
# preserve formatting
# expand variables

cat $1.tmpl \
	| sed "s#\${SASLDB_PATH}#${SASLDB_PATH}#g" \
	| sed "s#\${SASLDB_DIR}#${SASLDB_DIR}#g" \
	| sed "s#\${SSL_DIR}#${SSL_DIR}#g" \
	> $1

#render_template $1.tmpl > $1
