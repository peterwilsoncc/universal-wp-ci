#!/usr/bin/env bash

function set_environment_vars {
	if [ "$CIRCLECI" == 'true' ]; then
		UNICI_PROJECT_DIRECTORY=$( pwd ) # Circle CI's env-var for this doesn't quite work.
	elif [ "$TRAVIS" == 'true' ]; then
		UNICI_PROJECT_DIRECTORY=$TRAVIS_BUILD_DIR
	elif [ -f '/vagrant/content/config.yaml' ]; then
		UNICI_PROJECT_DIRECTORY=/vagrant/content
	fi

	WP_VERSION=${WP_VERSION:-latest}
	WP_TESTS_VERSION=${WP_TESTS_VERSION:-$WP_VERSION}

	UNICI_TMPDIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'unici-temp')
	WP_TESTS_DIR=${WP_TESTS_DIR:-$UNICI_TMPDIR/wpdevel/tests/phpunit}
}

function dump_enviroment_vars {
	for var in WP_VERSION WP_TESTS_VERSION UNICI_PROJECT_DIRECTORY UNICI_TMPDIR WP_TESTS_DIR; do
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
