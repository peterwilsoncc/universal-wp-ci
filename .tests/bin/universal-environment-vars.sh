#!/usr/bin/env bash

function download {
	if [ `which curl` ]; then
		curl -sL "$1" > "$2";
	elif [ `which wget` ]; then
		wget -nv -O "$2" "$1"
	fi
}

function set_environment_vars {
	if [ "$CIRCLECI" == 'true' ]; then
		UNICI_PROJECT_DIRECTORY=$( pwd ) # Circle CI's env-var for this doesn't quite work.
		UNICI_DB_NAME=${UNICI_DB_NAME:-wordpress_test}
		UNICI_DB_USER=${UNICI_DB_USER:-root}
		UNICI_DB_PASS=${UNICI_DB_PASS:-''}
		UNICI_DB_HOST=${UNICI_DB_HOST:-127.0.0.1}
	elif [ "$TRAVIS" == 'true' ]; then
		UNICI_PROJECT_DIRECTORY=$TRAVIS_BUILD_DIR
		UNICI_DB_NAME=${UNICI_DB_NAME:-wordpress_test}
		UNICI_DB_USER=${UNICI_DB_USER:-root}
		UNICI_DB_PASS=${UNICI_DB_PASS:-''}
		UNICI_DB_HOST=${UNICI_DB_HOST:-127.0.0.1}
	elif [ -f '/vagrant/content/config.yaml' ]; then
		UNICI_PROJECT_DIRECTORY=/vagrant/content
		UNICI_DB_NAME=${UNICI_DB_NAME:-wordpress}
		UNICI_DB_USER=${UNICI_DB_USER:-wordpress}
		UNICI_DB_PASS=${UNICI_DB_PASS:-vagrantpassword}
		UNICI_DB_HOST=${UNICI_DB_HOST:-localhost}
	fi

	WP_VERSION=${WP_VERSION:-latest}
	WP_TESTS_VERSION=${WP_TESTS_VERSION:-$WP_VERSION}

	UNICI_TMPDIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'unici-temp')
	WP_TESTS_DIR=${WP_TESTS_DIR:-$UNICI_TMPDIR/wpdevel/tests/phpunit}
}

function dump_enviroment_vars {
	for var in WP_VERSION WP_TESTS_VERSION UNICI_PROJECT_DIRECTORY UNICI_DB_NAME UNICI_DB_USER UNICI_DB_PASS UNICI_DB_HOST UNICI_TMPDIR WP_TESTS_DIR; do
		echo "$var=${!var}"
		if [ "$CIRCLECI" == 'true' ]; then
			echo "export $var=${!var}" >> $BASH_ENV
		else
			export $var=$(eval echo "\$$var")
		fi
	done
}

set_environment_vars
dump_enviroment_vars
