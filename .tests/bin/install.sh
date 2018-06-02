#!/usr/bin/env bash

download() {
    if [ `which curl` ]; then
        curl -s -L "$1" > "$2";
    elif [ `which wget` ]; then
        wget -nv -L -O "$2" "$1"
    fi
}

download_wp_core() {
	if [ -d $WP_CORE_DIR ]; then
		return;
	fi

	mkdir -p $WP_CORE_DIR

	download https://github.com/WordPress/WordPress/archive/$WP_VERSION.tar.gz $UNICI_TMPDIR/wordpress-core.tar.gz
	tar --strip-components=1 -zxmf $UNICI_TMPDIR/wordpress-core.tar.gz -C $WP_CORE_DIR
}

download_wp_tests() {
	if [ -d $WP_TESTS_DIR ]; then
		return;
	fi

	mkdir -p $WP_TESTS_DIR

	download https://github.com/WordPress/wordpress-develop/archive/$WP_TESTS_VERSION.tar.gz $UNICI_TMPDIR/wordpress-tests.tar.gz
	tar --strip-components=1 -zxmf $UNICI_TMPDIR/wordpress-tests.tar.gz -C $WP_TESTS_DIR
}

install_db() {
	if [ ${SKIP_DB_CREATE} = "true" ]; then
		return 0
	fi

	# parse DB_HOST for port or socket references
	local PARTS=(${UNICI_DB_HOST//\:/ })
	local DB_HOSTNAME=${PARTS[0]};
	local DB_SOCK_OR_PORT=${PARTS[1]};
	local EXTRA=""

	if ! [ -z $DB_HOSTNAME ] ; then
		if [ $(echo $DB_SOCK_OR_PORT | grep -e '^[0-9]\{1,\}$') ]; then
			EXTRA=" --host=$DB_HOSTNAME --port=$DB_SOCK_OR_PORT --protocol=tcp"
		elif ! [ -z $DB_SOCK_OR_PORT ] ; then
			EXTRA=" --socket=$DB_SOCK_OR_PORT"
		elif ! [ -z $DB_HOSTNAME ] ; then
			EXTRA=" --host=$DB_HOSTNAME --protocol=tcp"
		fi
	fi

	# create database
	mysqladmin create $UNICI_DB_NAME --user="$UNICI_DB_USER" --password="$UNICI_DB_PASS"$EXTRA
}

download_wp_core
download_wp_tests
install_db
