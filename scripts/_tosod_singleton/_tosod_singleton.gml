function destroy_singleton(scope) {
	// Delete store and cache of a particular singleton component

	if variable_struct_exists(global.cache, scope.NAME) {
		variable_struct_remove(global.cache, scope.NAME)
	}
	if variable_struct_exists(global.store, scope.NAME) {
		variable_struct_remove(global.store, scope.NAME)
	}
}
