function tosotest_preexecute_test() {
	// Purge storages
	global.store = {}
	global.cache = {}
	global.idmap = {}
	
	// Purge callbacks
	global.tosotest.execution.callbacks = {}
	global.tosotest.execution.has_callbacks = false
}


function tosotest_execute_test(signature) {
	// Print that we are running this signature
	print("  " + signature.name + "...")

	// Run this signature
	var status = global.tosotest.STATUSES.OK
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
