function string_join(separator, array) {
	// Coerces arguments to strings and concatenates them joined by separator.
	// Usage: 
	//   string_join(", ", [42, true, {}]) -> "42, true, {}"

	var output = ""
	var length = array_length(array)
	for (var argument_index = 0; argument_index < length; argument_index++) {
		output += string(array[argument_index])
		if argument_index != length - 1 {
			output += separator
		}
	}
	return output
}
