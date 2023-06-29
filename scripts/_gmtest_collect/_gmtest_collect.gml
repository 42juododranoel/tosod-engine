function _gmtest_collect() {
	// Collect all scripts that start with "test_" prefix.
	// Return them as array of ids.

	print()
	print("Collecting tests...")
	
	var script_index = global.GMTEST_SCRIPT_INDEX_START
	var test_ids = []
	
	while script_index < global.GMTEST_SCRIPT_INDEX_END {
		var is_script_present = script_exists(script_index)
		if is_script_present {
			var script_name = script_get_name(script_index)
			if string_pos(global.GMTEST_NAME_PREFIX, script_name) == 1 {
				array_push(test_ids, script_index)
			}
		}
		script_index += 1
	}
	
	print("Collected:", array_length(test_ids))	
	
	return test_ids
}
