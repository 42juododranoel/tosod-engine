function print() {
	// Coerces arguments to strings and prints them joined by spaces.
	// Usage: 
	//   print(42, true, {}) -> prints "42 true {}"

	var output = ""
	for (var argument_index = 0; argument_index < argument_count; argument_index++) {
		output += string(argument[argument_index])
		if argument_index != argument_count - 1 {
			output += " "
		}
	}
	show_debug_message(output)
}
