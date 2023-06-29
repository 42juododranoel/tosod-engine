function deep_compare(left, right) {
	// Compare left and right equality.
	// Supports struct and array nested checks.
	
	var left_type = typeof(left)
	if left_type != typeof(right) {
		return false
	}

	switch left_type {
		case "struct":
			var left_keys = variable_struct_get_names(left);
			var left_key_count = array_length(left_keys)
	
			var right_keys = variable_struct_get_names(right);
			var right_key_count = array_length(right_keys)
	
			if left_key_count != right_key_count {
				return false
			}
	
			for (var key_index = 0; key_index < left_key_count; key_index++) {
				var new_left_key = left_keys[key_index]
				var new_left = variable_struct_get(left, new_left_key)
		
				var new_right_key = right_keys[key_index]
				var new_right = variable_struct_get(right, new_right_key)
		
				var are_keys_equal = deep_compare(new_left, new_right)
				if not are_keys_equal {
					return false
				}
			}
			break
		case "array":
			var left_item_count = array_length(left)
			var right_item_count = array_length(right)
		
			if left_item_count != right_item_count {
				return false
			}

			for (var item_index = 0; item_index < left_item_count; item_index++) {
				var new_left = left[item_index]
				var new_right = right[item_index]
		
				var are_items_equal = deep_compare(new_left, new_right)
				if not are_items_equal {
					return false
				}
			}
			break
		default:
			if left != right {
				return false
			}
			break
	}
	return true
}
