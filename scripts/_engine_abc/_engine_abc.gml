function get_engine_constants() {
	return {
		// Purgable globals are removed before each test
		// to ensure consistent testing environment
		PURGABLE_GLOBALS: [
			// Storages
			"store",
			"cache",
			"idmap",
			// Constants
			"APPLICATION",
		],
	}
}
