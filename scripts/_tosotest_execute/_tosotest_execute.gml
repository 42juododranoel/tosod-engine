function tosotest_execute_fixture(dependency, results) {
	// Execute all its dependencies and the fixture itself after everything is OK

	for (var dependency_index = 0; dependency_index < array_length(dependency[1].depends); dependency_index++) {
		var dependency_name = dependency[1].depends[dependency_index][0]
		var dependency_fixture = dependency[1].depends[dependency_index][1]
				
		var dependency_result = tosotest_execute_fixture([dependency_name, dependency_fixture], results)
		variable_struct_set(results, dependency_name, dependency_result)
	}
	
	return dependency[1].fixture(results)
}


function tosotest_preexecute_test(signature) {
	// Purge storages
	global.store = {}
	global.cache = {}
	global.idmap = {}
	
	// Purge callbacks
	global.tosotest.execution.callbacks = {}
	global.tosotest.execution.has_callbacks = false

	var signature_fixture_graph =  {}
	var testsuits_fixture_graph = variable_struct_get(global.tosotest.collection.testsuit_fixture_graph, signature.app_name)
	var testsuit_fixture_graph = variable_struct_get(testsuits_fixture_graph, signature.testsuit_name)

	// Resolve test-level fixtures
	var test_fixture_names = variable_struct_get_names(signature.fixtures)
	for (var fixture_index = 0; fixture_index < array_length(test_fixture_names); fixture_index++) {
		var fixture_name = test_fixture_names[fixture_index]
		var fixture = variable_struct_get(signature.fixtures, fixture_name)
		var resolved_fixture = tosotest_resolve_test_fixture(fixture, testsuit_fixture_graph, signature.fixtures)
		variable_struct_set(signature_fixture_graph, fixture_name, resolved_fixture)
	}

	// Prepare and execute dependencies
	for (var dependency_index = 0; dependency_index < array_length(signature.fixture_depends); dependency_index++) {
		var dependency_name = signature.fixture_depends[dependency_index]
		
		// Get resolved dependency
		var resolved_dependency = variable_struct_getdefault(signature_fixture_graph, dependency_name, undefined)
		if is_undefined(resolved_dependency) {
			resolved_dependency = variable_struct_getdefault(testsuit_fixture_graph, dependency_name, undefined)		
		}
		if is_undefined(resolved_dependency) {
			resolved_dependency = variable_struct_getdefault(global.tosotest.collection.app_fixture_graph, dependency_name, undefined)		
		}

		var dependency_value = tosotest_execute_fixture([dependency_name, resolved_dependency], signature.fixture_results)
		variable_struct_set(signature.fixture_results, dependency_name, dependency_value)
	}
}


function tosotest_execute_test(signature) {
	// Print that we are running this signature
	print("  " + signature.name + "...")

	// Run this signature
	var status = global.tosotest.STATUSES.OK
	var error = undefined

	tosotest_preexecute_test(signature)
	var arguments = []
	var arguments_count = 0
	// Prepare fixtures
	if array_length(signature.fixture_depends) > 0 {
		arguments_count += 1
		array_push(arguments, signature.fixture_results)
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
	} catch(exception) {
		status = global.tosotest.STATUSES.FAIL
		error = exception
	} finally {
		var result = {
			name: signature.name,
			status: status, 
			error: error,
		}
	}
	global.tosotest.execution.statistics.total += 1

	// If no on_room_start() was executed in test body
	if not global.tosotest.execution.has_callbacks {
		tosotest_postexecute_test(result)
	}
	// Otherwise wait for them to trigger
}


function tosotest_postexecute_test(result) {
	// Save results
	variable_struct_set(global.tosotest.execution.results, result.name, result)

	// Update statistics
	if result.status == global.tosotest.STATUSES.OK {
		global.tosotest.execution.statistics.passed += 1
	}
	if result.status == global.tosotest.STATUSES.FAIL {
		global.tosotest.execution.statistics.failed += 1
		
		// Leave if exitfirst
		if global.tosotest.EXITFIRST {
			tosotest_report()
		}
	}

	// Prepare to run next test
	global.tosotest.execution.signature_index += 1
	if global.tosotest.execution.signature_index < global.tosotest.collection.statistics.test_count {
		// Destroy current test object, to start from scratch again
		instance_destroy(global.tosotest.execution.object_id)
		room_goto(room_tosotest)
	} else {
		// That was the last signature, go report results
		tosotest_report()		
	}
}
