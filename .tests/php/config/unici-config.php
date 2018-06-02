<?php

// Configure database for testing.
define( 'DB_HOST', getenv( 'UNICI_DB_HOST' ) );
define( 'DB_NAME', getenv( 'UNICI_DB_NAME' ) );
define( 'DB_USER', getenv( 'UNICI_DB_USER' ) );
define( 'DB_PASSWORD', getenv( 'UNICI_DB_PASS' ) );

define( 'UNICI_ENV', 'ci' );

// Define path & url for Content.
define( 'WP_CONTENT_DIR', getenv( 'UNICI_PROJECT_DIRECTORY' ) );

// Absolute path to the WordPress directory.
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', getenv( 'WP_CORE_DIR' ) . '/' );
}
