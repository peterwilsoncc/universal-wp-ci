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
		UNICI_ENV=circle
		UNICI_PROJECT_DIRECTORY=$( pwd ) # Circle CI's env-var for this doesn't quite work.
		UNICI_DB_NAME=${UNICI_DB_NAME:-wordpress_test}
		UNICI_DB_USER=${UNICI_DB_USER:-root}
		UNICI_DB_PASS=${UNICI_DB_PASS:-''}
		UNICI_DB_HOST=${UNICI_DB_HOST:-127.0.0.1}
	elif [ "$TRAVIS" == 'true' ]; then
		UNICI_ENV=travis
		UNICI_PROJECT_DIRECTORY=$TRAVIS_BUILD_DIR
		UNICI_DB_NAME=${UNICI_DB_NAME:-wordpress_test}
		UNICI_DB_USER=${UNICI_DB_USER:-root}
		UNICI_DB_PASS=${UNICI_DB_PASS:-''}
		UNICI_DB_HOST=${UNICI_DB_HOST:-127.0.0.1}
	elif [ -f '/vagrant/content/config.yaml' ]; then
		UNICI_ENV=chassis
		UNICI_PROJECT_DIRECTORY=/vagrant/content
		UNICI_DB_NAME=${UNICI_DB_NAME:-wordpress}
		UNICI_DB_USER=${UNICI_DB_USER:-wordpress}
		UNICI_DB_PASS=${UNICI_DB_PASS:-vagrantpassword}
		UNICI_DB_HOST=${UNICI_DB_HOST:-localhost}
	fi

	WP_VERSION=${WP_VERSION:-latest}
	WP_TESTS_VERSION=${WP_TESTS_VERSION:-$WP_VERSION}

	UNICI_TMPDIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'unici-temp')
	WP_DEVEL_DIR=${WP_DEVEL_DIR:-$UNICI_TMPDIR/wpdevel}
	WP_CORE_DIR=${WP_CORE_DIR:-$UNICI_TMPDIR/wpcore}

	WP_TESTS_DIR=$WP_DEVEL_DIR/tests/phpunit
}

function clean_wp_version_vars {
	# WordPress archives will be downloaded from GitHub, so we need to do a
	# bit of tidy up to allow for common terms.

	# Downloading and grepping the latest version taken from WP-CLI scaffolds.
	if [[ $WP_TESTS_VERSION == 'latest' || $WP_VERSION == 'latest' ]]; then
		download http://api.wordpress.org/core/version-check/1.7/ $UNICI_TMPDIR/wp-latest.json
		grep '[0-9]+\.[0-9]+(\.[0-9]+)?' $UNICI_TMPDIR/wp-latest.json
		local latest_version=$(grep -o '"version":"[^"]*' $UNICI_TMPDIR/wp-latest.json | sed 's/"version":"//')
		if [[ -z "$latest_version" ]]; then
			echo "Latest WordPress version could not be found"
			exit 1
		fi
		if [[ $WP_TESTS_VERSION == 'latest' ]]; then
			WP_TESTS_VERSION=$latest_version
		fi
		if [[ $WP_VERSION == 'latest' ]]; then
			WP_VERSION=$latest_version
		fi
	fi

	# x.x releases of WordPress Develop are tagged x.x.0
	if [[ $WP_TESTS_VERSION =~ ^[0-9]+\.[0-9]+$ ]]; then
		WP_TESTS_VERSION=${WP_TESTS_VERSION}.0
	elif [[ $WP_TESTS_VERSION == 'nightly' || $WP_TESTS_VERSION == 'trunk' ]]; then
		WP_TESTS_VERSION=master
	fi

	# x.x releases of WordPress Core are tagged x.x
	if [[ $WP_VERSION =~ [0-9]+\.[0-9]+\.[0] ]]; then
		# version x.x.0 means the first release of the major version, so strip off the .0 and download version x.x
		WP_VERSION=${WP_VERSION%??}
	elif [[ $WP_VERSION == 'nightly' || $WP_VERSION == 'trunk' ]]; then
		WP_VERSION=master
	fi
}

function dump_enviroment_vars {
	for var in WP_VERSION WP_TESTS_VERSION UNICI_ENV UNICI_PROJECT_DIRECTORY UNICI_DB_NAME UNICI_DB_USER UNICI_DB_PASS UNICI_DB_HOST UNICI_TMPDIR WP_DEVEL_DIR WP_CORE_DIR WP_TESTS_DIR; do
		echo "$var=${!var}"
		if [ "$CIRCLECI" == 'true' ]; then
			echo "export $var=${!var}" >> $BASH_ENV
		else
			export $var=$(eval echo "\$$var")
		fi
	done
}

set_environment_vars
clean_wp_version_vars
dump_enviroment_vars
