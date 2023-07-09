function TosotestApp(): App("tosotest") constructor {
	// Constants

	RESULTS = {
		FAIL: 0,
		OK: 1,
	}
	
	EXITFIRST = true
	
	
	// ABC
	
	static start = function() {
		// Run this function to start testing

		var tree = tosotest_collect()
		var results = tosotest_execute(tree)
		tosotest_report(results)
		game_end()
	}


	// Tests

	static get_testsuits = function() {
		return [
			get_tosotest_syntax_testsuit,
		]
	}
}
