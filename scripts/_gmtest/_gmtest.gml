function gmtest() {
	// Run this function to start testing run
	
	var test_names = _gmtest_collect()
	var results = _gmtest_run(test_names)
	_gmtest_report(results)
	game_end()
}
