<?php
// @codingStandardsIgnoreFile
if ( getenv( 'UNICI_ENV' ) ) {
	require_once __DIR__ . '/config/unici-config.php';
} else {
	require_once __DIR__ . '/config/chassis-config.php';
}


$_SERVER['HTTP_HOST'] = '127.0.0.1';
$table_prefix = 'wptests_';

define( 'WP_TESTS_DOMAIN', '127.0.0.1' );
define( 'WP_TESTS_EMAIL', 'admin@example.org' );
define( 'WP_TESTS_TITLE', 'Test Blog' );

define( 'WP_PHP_BINARY', 'php' );
define( 'WP_TESTS_MULTISITE', false );


// Define Site URL: WordPress in a subdirectory.
if ( ! defined( 'WP_SITEURL' ) ) {
	define( 'WP_SITEURL', 'http://' . $_SERVER['HTTP_HOST'] );
}

// Define Home URL
if ( ! defined( 'WP_HOME' ) ) {
	define( 'WP_HOME', 'http://' . $_SERVER['HTTP_HOST'] );
}

// Prevent editing of files through the admin.
define( 'DISALLOW_FILE_EDIT', true );
define( 'DISALLOW_FILE_MODS', true );
