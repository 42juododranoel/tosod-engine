function variable_struct_values(struct) {
	// Return struct's values
	
	var names = variable_struct_get_names(struct)
	var name_count = array_length(names)
	var values = []
	for (var name_index = 0; name_index < name_count; name_index++) {
		var name = names[name_index]
		var value = variable_struct_get(struct, name)
		array_push(values, value)
	}
	return values
}


function variable_struct_getdefault(struct, name, default_value) {
	// Return the key value or default value if key is missing
	
	if variable_struct_exists(struct, name) {
		return variable_struct_get(struct, name)
	} else {
		return default_value
	}
}


function variable_struct_shallowcopy(struct) {
	// Non-recursively copy a struct

	var new_struct = {}
	var struct_keys = variable_struct_get_names(struct)
	for (var index = 0; index < array_length(struct_keys); index++) {
		var key = struct_keys[index]
		var value = variable_struct_get(struct, key)
		variable_struct_set(new_struct, key, value)
	}
	return new_struct
}


function variable_struct_fromitems(items) {
	// Create a struct from an array of key-value pairs

	var new_struct = {}
	for (var item_index = 0; item_index < array_length(items); item_index++) {
		var item = items[item_index]
		variable_struct_set(new_struct, item[0], item[1])
	}	
	return new_struct
}


function variable_struct_defined(struct, name) {
	// Check if key exists and is non-undefined
	return variable_struct_exists(struct, name) and check_defined(variable_struct_get(struct, name))
}

