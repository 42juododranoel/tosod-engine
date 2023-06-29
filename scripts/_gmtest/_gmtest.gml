global.PURGABLE_GLOBALS = []  // These globals are purged before each run

global.GMTEST_RESULT = {
	FAIL: 0,
	OK: 1,
}
global.GMTEST_NAME_PREFIX = "test_"

global.GMTEST_SCRIPT_INDEX_START = 100000
global.GMTEST_SCRIPT_INDEX_END = 101000


function gmtest() {
	// Run this function to start testing run
	
	var test_names = _gmtest_collect()
	var results = _gmtest_run(test_names)
	_gmtest_report(results)
	game_end()
}
