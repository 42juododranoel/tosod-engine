function tosotest_collect() {
	// Collect all tests from each app.

	print()
	print("Collecting tests...")

	// First we prepare
	tosotest_resolve_apps_fixtures()
	
	// For each app in apps
	var app_names = variable_struct_get_names(global.apps)
	for (var app_index = 0; app_index < array_length(app_names); app_index++) {
		var app_name = app_names[app_index]
		var app = variable_struct_get(global.apps, app_name)
		global.tosotest.collection.statistics.app_count += 1

		// Resolve this app's testsuit's fixtures
		tosotest_resolve_app_testsuits_fixtures(app)

		// For each testusit of this app's testsuits
		var app_testsuits = app.get_testsuits()
		for (var testsuit_index = 0; testsuit_index < array_length(app_testsuits); testsuit_index++) {
			var testsuit = app_testsuits[testsuit_index]()
			global.tosotest.collection.statistics.testsuit_count += 1

			// For each test in testsuit prepare signatures
			var test_names = variable_struct_get_names(testsuit.tests)
			for (var test_index = 0; test_index < array_length(test_names); test_index++) {
				var test_name = test_names[test_index]
				var test = variable_struct_get(testsuit.tests, test_name)

				var base_signature = {
					name: app.name + "::" + testsuit.name + "::" + test_name,
					test: test.test,
					app_name: app.name,
					testsuit_name: testsuit.name,
					test_name: test_name,
					// Parametrization
					is_parametrized: false,
					params: {},
					// Fixtures
					fixtures: variable_struct_getdefault(test, "fixtures", {}),
					fixture_depends: variable_struct_getdefault(test, "depends", []),
					fixture_results: {},
				}

				// Each test is represented by one or more signatures in an array
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
						var test_signature = variable_struct_shallowcopy(base_signature)						
						test_signature.params = params
						test_signature.is_parametrized = true
						test_signature.name += "[" + string_join(",", variable_struct_values(params)) + "]"
						array_push(global.tosotest.collection.signatures, test_signature)
						global.tosotest.collection.statistics.test_count += 1
					}
				} else {
					// Add non-parametrized test signature
					var test_signature = variable_struct_shallowcopy(base_signature)					
					array_push(global.tosotest.collection.signatures, test_signature)
					global.tosotest.collection.statistics.test_count += 1
				}
			}
		}
	}	

	print("Collected", global.tosotest.collection.statistics.test_count, "tests in", global.tosotest.collection.statistics.testsuit_count, "testsuits across", global.tosotest.collection.statistics.app_count, "apps.")	
}
