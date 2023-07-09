function assert() {
	// If one argument is provided, checks if it evaluates to true
	// If two arguments are provided, checks if left equals right

	if argument_count == 1 {
		if not check_defined(argument[0]) and not argument[0] {
			show_error("Assert error: " + string(argument[0]) + " is not true.", true)
		}
	} else {
		var left = argument[0]
		var right = argument[1]

		var is_equal = deep_compare(left, right)		
		if not is_equal {
			show_error("Assert error: " + string(left) + " != " + string(right), true)
		}
	}
	
	
}
