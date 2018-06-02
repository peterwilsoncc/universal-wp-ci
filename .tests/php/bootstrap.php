<?php
// @codingStandardsIgnoreFile

// On Chassis, tests can silently fail, so introduce a shutdown function to print the last error.
// Throwing an exception sends a non-zero exit code.
register_shutdown_function( function() {
	$error = error_get_last();
	if ( $error ) {
		throw new Exception( $error['message'] );
	}
} );

if ( getenv( 'WP_TESTS_DIR' ) ) {
	$wp_develop_dir = getenv( 'WP_TESTS_DIR' );
} else {
	$wp_develop_dir = '/vagrant/extensions/Tester/wpdevel';
}

if ( file_exists( __DIR__ . '/includes/bootstrap.php' ) ) {
	/*
	 * Use the version of the test lib included here, presumably
	 * they were included for a reason.
	 */
	$wp_tests_dir = __DIR__;
} else {
	$wp_tests_dir = $wp_develop_dir . '/tests/phpunit';
}

require_once $wp_tests_dir . '/includes/functions.php';

function _register_theme() {

	$theme_dir = dirname( dirname( dirname( __FILE__ ) ) ) . '/themes/twentyfourteen';
	$current_theme = basename( $theme_dir );

	register_theme_directory( dirname( $theme_dir ) );

	add_filter( 'pre_option_template', function() use ( $current_theme ) {
		return $current_theme;
	});
	add_filter( 'pre_option_stylesheet', function() use ( $current_theme ) {
		return $current_theme;
	});

	// Set our permalink structure to always match production in tests.
	add_filter( 'pre_option_permalink_structure', function() {
		return '%year%/%monthnum%/%day%/%postname%';
	}, 99 );
}
tests_add_filter( 'muplugins_loaded', '_register_theme' );

/**
 * Re-map the default `/uploads` folder with our own `/test-uploads` for tests.
 *
 * WordPress core runs a method (scan_user_uploads) on the first instance of `WP_UnitTestCase`.
 * This method scans every single folder and file in the uploads directory.
 *
 * This filter adds a unique test uploads folder just for our tests to reduce load.
 */
tests_add_filter( 'upload_dir', function( $dir ) {
	array_walk( $dir, function( &$item ) {
		if ( is_string( $item ) ) {
			$item = str_replace( '/uploads', '/test-uploads', $item );
		}
	} );
	return $dir;
} );

require_once $wp_tests_dir . '/includes/bootstrap.php';
