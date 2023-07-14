function tosotest_collect() {
	// Collect all tests from each app.

	print()
	print("Collecting tests...")
	
	// Populate testing tree.
	// Tree consists of branches, each represents an app.
	// On each branch there are fixtures and testsuits, 
	// with each testsuit having its own fixtures,
	// and each test having its own fixtures.
	var tree = {
		branches: {},
		statistics: {
			app_count: 0,
			testsuit_count: 0,
			test_count: 0,
		},
	}
	
	// For each app in apps
	var app_names = variable_struct_get_names(global.apps)
	for (var app_index = 0; app_index < array_length(app_names); app_index++) {
		// Testing works app by app
		var app_name = app_names[app_index]
		var app = variable_struct_get(global.apps, app_name)
		tree.statistics.app_count += 1
		
		var branch = {
			testsuits: [],
		}
		variable_struct_set(tree.branches, app.name, branch)		
		
		// For each testusit of this app's testsuits
		var app_testsuits = app.get_testsuits()
		for (var testsuit_index = 0; testsuit_index < array_length(app_testsuits); testsuit_index++) {
			// A testsuit is lazy, execute it here and save for later
			var testsuit = app_testsuits[testsuit_index]()
			testsuit.signatures = {}
			tree.statistics.testsuit_count += 1
			
			// For each test in testsuit
			var test_names = variable_struct_get_names(testsuit.tests)
			for (var test_index = 0; test_index < array_length(test_names); test_index++) {
				var test_name = test_names[test_index]
				var test = variable_struct_get(testsuit.tests, test_name)

				// Each test is represented by one or more signatures in an array
				var test_signatures = []
				if variable_struct_exists(test, "parametrize") {
					// This test should be run multiple times with different params
					var parametrize_names = test.parametrize[0]
					var parametrize_values = test.parametrize[1]
					
					// For each parametrized batch
					for (var batch_index = 0; batch_index < array_length(parametrize_values); batch_index++) {
						// Prepare parametrize signature
						var params = {}
						for (var name_index = 0; name_index < array_length(parametrize_names); name_index++) {
							var parametrize_name = parametrize_names[name_index]
							var parametrize_value = parametrize_values[batch_index][name_index]
							variable_struct_set(params, parametrize_name, parametrize_value)
						}
						
						// Add parametrized test signature
						var test_signature = {
							params: params, 
							test: test.test,
							fixtures: variable_struct_getdefault(test, "fixtures", []),
							is_parametrized: true,
						}
						array_push(test_signatures, test_signature)
						tree.statistics.test_count += 1
					}
				} else {
					// Add non-parametrized test signature
					var test_signature = {
						params: {},
						test: test.test,
						fixtures: variable_struct_getdefault(test, "fixtures", []),
						is_parametrized: false,
					}
					array_push(test_signatures, test_signature)
					tree.statistics.test_count += 1
				}
				// Save collected signatures
				variable_struct_set(testsuit.signatures, test_name, test_signatures)
			}
			// Save collected testsuit
			array_push(branch.testsuits, testsuit)
		}
	}

	print("Collected", tree.statistics.test_count, "tests in", tree.statistics.testsuit_count, "testsuits across", tree.statistics.app_count, "apps.")	
	return tree
}
