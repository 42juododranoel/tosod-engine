function create_singleton(scope, store, cache) {
	// Create store and cache for a particular singleton component
	
	if variable_struct_exists(global.store, scope.NAME) {
		show_error("Store " + scope.NAME + " already exists", true)
	}
	variable_struct_set(global.store, scope.NAME, {})
	mutate(scope, "create_singleton", store)

	if variable_struct_exists(global.cache, scope.NAME) {
		show_error("Cache " + scope.NAME + " already exists", true)
	}
	variable_struct_set(global.cache, scope.NAME, {})
	remember(scope, "create_singleton", cache)
}


function destroy_singleton(scope) {
	// Delete store and cache of a particular singleton component

	if variable_struct_exists(global.cache, scope.NAME) {
		variable_struct_remove(global.cache, scope.NAME)
	}
	if variable_struct_exists(global.store, scope.NAME) {
		variable_struct_remove(global.store, scope.NAME)
	}
}
