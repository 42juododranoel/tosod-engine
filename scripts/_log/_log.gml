function log(scope, scope_id, message) {
	// Print storage debug transaction info
	
	var do_debug = variable_struct_get(global.APPLICATION, "DO_DEBUG_" + string_upper(scope))
	if do_debug {
		if check_defined(scope_id) {
			print(scope + "_" + string(scope_id) +  ": " + message)
		} else {
			print(scope + ": " + message)
		}
	}
}
