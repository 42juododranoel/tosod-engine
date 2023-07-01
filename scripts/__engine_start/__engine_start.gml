function start_engine() {
	// 1. Define constants

	global.ENGINE = get_engine_constants()
	

	// 4. Run component
	
	if debug_mode {
		// Update purgable globals
		global.GMTEST = get_gmtest_constants()
		global.GMTEST.PURGABLE_GLOBALS = global.ENGINE.PURGABLE_GLOBALS

		// Run tests
		gmtest()
	} else {
		// "This is where the fun begins" (c)
		start_application()
	}
}
