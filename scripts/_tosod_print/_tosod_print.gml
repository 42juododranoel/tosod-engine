function print() {
	// Coerces arguments to strings and prints them joined by spaces.
	// Usage: 
	//   print(42, true, {}) -> prints "42 true {}"

	var arguments = []
	for (var argument_index = 0; argument_index < argument_count; argument_index++) {
		array_push(arguments, argument[argument_index])
	}
	var output = string_join(" ", arguments)
	show_debug_message(output)
}
