#!/usr/bin/env bash

download() {
    if [ `which curl` ]; then
        curl -s "$1" > "$2";
    elif [ `which wget` ]; then
        wget -nv -O "$2" "$1"
    fi
}

download_wp_core() {
	if [ -d $WP_CORE_DIR ]; then
		return;
	fi

	mkdir -p $WP_CORE_DIR

	download https://github.com/WordPress/WordPress/archive/$WP_VERSION.tar.gz  $UNICI_TMPDIR/wordpress-core.tar.gz
	tar --strip-components=1 -zxmf $UNICI_TMPDIR/wordpress-core.tar.gz -C $WP_CORE_DIR
}

download_wp_tests() {
	if [ -d $WP_TESTS_DIR ]; then
		return;
	fi

	mkdir -p $WP_TESTS_DIR

	download https://github.com/WordPress/wordpress-develop/archive/$WP_TESTS_VERSION.tar.gz  $UNICI_TMPDIR/wordpress-tests.tar.gz
	tar --strip-components=1 -zxmf $UNICI_TMPDIR/wordpress-tests.tar.gz -C $WP_TESTS_DIR
}

download_wp_core
download_wp_tests
