REPO := kadock
NAME := s6-postfix
TAG := latest
IMAGE := ${REPO}/${NAME}:${TAG}

export SASLDB_DIR = /var/lib/sasl2
export SASLDB_PATH = /var/lib/sasl2/sasldb2
export SSL_DIR = /etc/postfix/ssl

generate:
	./gen.sh Docker/s6/fix-attrs.d/01-sasl2-db-dir
	./gen.sh Docker/s6/cont-init.d/01-sasl2-db-create
	./gen.sh Docker/sasl2/smtpd.conf
	./gen.sh Docker/certmgr/get_all


build: generate
	docker build --build-arg SASLDB_DIR=${SASLDB_DIR} --build-arg SSL_DIR=${SSL_DIR} -t ${IMAGE} Docker
