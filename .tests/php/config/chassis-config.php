<?php

// Configure database for testing.
define( 'DB_HOST', 'localhost' );
define( 'DB_NAME', 'wordpress' );
define( 'DB_USER', 'wordpress' );
define( 'DB_PASSWORD', 'vagrantpassword' );

define( 'UNICI_ENV', 'chassis' );

// Define path & url for Content
define( 'WP_CONTENT_DIR', __DIR__ . '/../../../' );

// Absolute path to the WordPress directory.
if ( ! defined( 'ABSPATH' ) ) {
	define( 'WP_CONTENT_DIR', __DIR__ . '/../../../../wp/' );
}
