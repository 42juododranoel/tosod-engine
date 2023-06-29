function _gmtest_prerun_test() {
	// Clear configured globals before running
	
	for (var global_index = 0; global_index < array_length(global.PURGABLE_GLOBALS); global_index++) {
		var global_key = global.PURGABLE_GLOBALS[global_index]
		variable_global_set(global_key, undefined)
		print("purging")
	}
}


function _gmtest_postrun_test() {

}


function _gmtest_run(test_ids) {
	// Run tests

	var results = {}

	var test_count = array_length(test_ids)
	for (var test_index = 0; test_index < test_count; test_index++) {
		var test_id = test_ids[test_index]
		var test_name = script_get_name(test_id)
		print("  " + test_name + "...")

		var status = global.GMTEST_RESULT.OK
		var error = undefined

		_gmtest_prerun_test()
		try {
			script_execute(test_id)
		} catch(exception) {
			status = global.GMTEST_RESULT.FAIL
			error = exception
		} finally {
			var result = {status: status, error: error}
			variable_struct_set(results, test_name, result)
		}
		_gmtest_postrun_test()
	}

	return results
}
