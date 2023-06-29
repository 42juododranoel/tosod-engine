function _gmtest_report(results) {
	// Write test results as show_debug_message calls.
	// Provide stacktrace, long and short error messages.
	// Print fails, total and ok runs.

	print()
	print("Reporting results...")
	
	var test_names = variable_struct_get_names(results)
	var test_count = array_length(test_names)
	
	var ok_count = 0
	var fail_count = 0

	for (var test_name_index = 0; test_name_index < test_count; test_name_index++) {
		var test_name = test_names[test_name_index]
		var test_result = variable_struct_get(results, test_name)
		
		switch test_result.status {
			case global.GMTEST_RESULT.OK:
				ok_count += 1
				break
			case global.GMTEST_RESULT.FAIL:
				fail_count += 1
				
				var long_message = test_result.error.longMessage
				long_message = string_replace_all(long_message, "\n\n", "\n")
				long_message = string_replace_all(long_message, "\n", "\n| ")
				
				print()
				print("+—————————————————————————————————————————————————————————————————————————————————————")
				print("|", test_name, "failed:", test_result.error.message)
				print("+—————————————————————————————————————————————————————————————————————————————————————")
				print("|", long_message)
				for (var stacktace_line_index = 0; stacktace_line_index < array_length(test_result.error.stacktrace); stacktace_line_index++) {
					print("|", test_result.error.stacktrace[stacktace_line_index])
				}
				print("+—————————————————————————————————————————————————————————————————————————————————————")
				break
		}
	}
	
	print()
	print("OK:", ok_count)
	print("Failed:", fail_count)
	print("Total:", test_count)
	print()
}
