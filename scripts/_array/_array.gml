function array_in(array, element) {
	// Check if the element is in the array
	
	for (var array_element_index = 0; array_element_index < array_length(array); array_element_index++) {
		var array_element = array[array_element_index]	
		if array_element == element {
			return true
		}
	}
	return false
}
