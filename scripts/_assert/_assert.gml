function assert(left, right) {
	// Check if left equals right, throw an errow if it doesn't
	
	var is_equal = deep_compare(left, right)		
	if not is_equal {
		show_error("Assert error: " + string(left) + " != " + string(right), true)
	}
}
