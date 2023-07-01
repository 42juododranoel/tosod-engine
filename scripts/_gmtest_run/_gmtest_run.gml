function _gmtest_prerun_test() {
	// Clear configured globals before running
	
	for (var global_index = 0; global_index < array_length(global.GMTEST.PURGABLE_GLOBALS); global_index++) {
		var global_key = global.GMTEST.PURGABLE_GLOBALS[global_index]
		variable_global_set(global_key, undefined)
	}
	
	
	// Goto test room to undo previous room gotos
	
	room_goto(room_gmtest)
}


function _gmtest_postrun_test() {

}


function _gmtest_run(test_ids) {
	// Run tests
	
	print()
	print("Running tests...")

	var results = {
		tests: {},
		statistics: {
			total: 0,
			passed: 0,
			failed: 0,
		}
	}

	var test_count = array_length(test_ids)
	for (var test_index = 0; test_index < test_count; test_index++) {
		var test_id = test_ids[test_index]
		var test_name = script_get_name(test_id)
		print("  " + test_name + "...")

		var status = global.GMTEST.RESULTS.OK
		var error = undefined

		_gmtest_prerun_test()
		try {
			script_execute(test_id)
			results.statistics.passed += 1
		} catch(exception) {
			status = global.GMTEST.RESULTS.FAIL
			error = exception
			results.statistics.failed += 1
		} finally {
			var result = {status: status, error: error}
			variable_struct_set(results.tests, test_name, result)
			results.statistics.total += 1
		}
		_gmtest_postrun_test()
		
		if global.GMTEST.EXITFIRST and status == global.GMTEST.RESULTS.FAIL {
			break
		}
	}

	return results
}
