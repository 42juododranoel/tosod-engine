function _store(parent_storage, allowed_keys_name, log_phrase, scope, scope_id, caller, items) {
	// Get storage from constants
	var storage = variable_struct_get(parent_storage, scope.NAME)

	// Validate inputs
	var keys = variable_struct_get_names(items)	
	if check_defined(allowed_keys_name) {
		var allowed_keys = variable_struct_get(scope, allowed_keys_name)
		for (var key_index = 0; key_index < array_length(keys); key_index++) {
			var key = keys[key_index]
			var is_key_allowed = array_in(allowed_keys, key)
			if not is_key_allowed {
				show_error("Bad cache key " + key, true)
			}
		}
	}

	// Update storage
	for (var key_index = 0; key_index < array_length(keys); key_index++) {
		var key = keys[key_index]
		var value = variable_struct_get(items, key)
		variable_struct_set(storage, key, value)
	}
	
	// Log this transaction
	log(scope, scope_id, caller + log_phrase + string(items))
}


function remember(scope, caller, items) {
	_store(global.cache, "CACHE_KEYS", " remembers ", scope, undefined, caller, items)
}


function iremember(scope, scope_id, caller, items) {
	_store(global.cache, "CACHE_KEYS", " remembers ", scope, scope_id, caller, items)
}


function mutate(scope, caller, items) {
	_store(global.store, "STORE_KEYS", " mutates ", scope, undefined, caller, items)
}


function imutate(scope, scope_id, caller, items) {
	_store(global.store, "STORE_KEYS", " mutates ", scope, scope_id, caller, items)
}
