function tosotest_report(results) {
	// Write test results as show_debug_message calls.
	// Provide stacktrace, long and short error messages.
	// Print fails, total and ok runs.

	print()
	print("Reporting results...")
	
	var test_names = variable_struct_get_names(results.tests)
	var test_count = array_length(test_names)
	
	for (var test_name_index = 0; test_name_index < test_count; test_name_index++) {
		var test_name = test_names[test_name_index]
		var test_result = variable_struct_get(results.tests, test_name)
		
		if test_result.status == global.tosotest.RESULTS.FAIL {				
			var long_message = test_result.error.longMessage
			long_message = string_replace_all(long_message, "\n\n", "\n")
			long_message = string_replace_all(long_message, "\n", "\n| ")

			print()
			print("+—————————————————————————————————————————————————————————————————————————————————————")
			print("|", test_result.name, test_result.error.message)
			print("+—————————————————————————————————————————————————————————————————————————————————————")
			print("|", long_message)
			for (var stacktace_line_index = 0; stacktace_line_index < array_length(test_result.error.stacktrace); stacktace_line_index++) {
				print("|", test_result.error.stacktrace[stacktace_line_index])
			}
			print("+—————————————————————————————————————————————————————————————————————————————————————")
		}
	}
	
	print()
	print("Total:", results.statistics.total)
	print("Passed:", results.statistics.passed)
	print("Failed:", results.statistics.failed)
	print()
}
