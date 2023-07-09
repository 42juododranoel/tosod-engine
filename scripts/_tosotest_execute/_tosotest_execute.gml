function tosotest_preexecute_test() {

}


function tosotest_postexecute_test() {

}


function tosotest_execute(tree) {
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
	
	// For each branch
	var branch_names = variable_struct_get_names(tree.branches)
	for (var branch_index = 0; branch_index < array_length(branch_names); branch_index++) {
		var branch_name = branch_names[branch_index]
		var branch = variable_struct_get(tree.branches, branch_name)

		// For each testsuit in branch
		for (var testsuit_index = 0; testsuit_index < array_length(branch.testsuits); testsuit_index++) {
			var testsuit = branch.testsuits[testsuit_index]

			// For each test in testsuit
			var test_names = variable_struct_get_names(testsuit.signatures)
			for (var test_index = 0; test_index < array_length(test_names); test_index++) {
				var test_name = test_names[test_index]
				var test_signatures = variable_struct_get(testsuit.signatures, test_name)

				// For each signature in test signatures
				var signature_count = array_length(test_signatures)
				for (var signature_index = 0; signature_index < signature_count; signature_index++) {
					var signature = test_signatures[signature_index]
					
					// Print that we are running this signature
					if signature_count > 1 {
						var params_slug = string_join(",", variable_struct_values(signature.params))
						var signature_name = branch_name + "::" + testsuit.name + "::" + test_name + "[" + params_slug + "]"
					} else {
						var signature_name = branch_name + "::" + testsuit.name + "::" + test_name
					}
					print("  " + signature_name + "...")

					// Run this signature
					var status = global.TOSOTEST.RESULTS.OK
					var error = undefined

					tosotest_preexecute_test()
					var arguments = []
					var arguments_count = 0
					// Prepare fixtures
					if array_length(signature.fixtures) > 0 {
						var fixtures = {}
						arguments_count += 1
						array_push(arguments, fixtures)
					}
					// Prepare params
					if signature.is_parametrized {
						arguments_count += 1
						array_push(arguments, signature.params)						
					}
					// Execute with error catching
					try {
						switch arguments_count {
							case 0:
								signature.test()
								break
							case 1:
								signature.test(arguments[0])
								break
							case 2:
								signature.test(arguments[0], arguments[1])
								break
						}						
						results.statistics.passed += 1
					} catch(exception) {
						status = global.TOSOTEST.RESULTS.FAIL
						error = exception
						results.statistics.failed += 1
					} finally {
						var result = {
							name: signature_name,
							status: status, 
							error: error,
						}
						variable_struct_set(results.tests, test_name, result)
						results.statistics.total += 1
					}
					tosotest_postexecute_test()

					// Leave if exitfirst
					if global.TOSOTEST.EXITFIRST and status == global.TOSOTEST.RESULTS.FAIL {
						break
					}
				}
			}
		}	
	}

	return results
}
