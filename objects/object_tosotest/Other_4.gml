var key = global.tosotest.EVENTS.ROOM_START

var callback = variable_struct_getdefault(
	global.tosotest.execution.callbacks, 
	global.tosotest.EVENTS.ROOM_START, 
	undefined,
)

if check_defined(callback) {
	// Execute callback with error catching
	var signature = global.tosotest.collection.signatures[global.tosotest.execution.signature_index]
	var status = global.tosotest.STATUSES.OK
	var error = undefined
	try {
		callback()
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
	
	// Remove this callback from signature
	variable_struct_remove(global.tosotest.execution.callbacks, global.tosotest.EVENTS.ROOM_START)
	
	// Call postexecute if that was the last callback or this signature failed
	if array_length(variable_struct_get_names(global.tosotest.execution.callbacks)) == 0 or result == global.tosotest.STATUSES.FAIL {
		tosotest_postexecute_test(result)
	}
}
