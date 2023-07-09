function App(_name) constructor {
	name = _name

	array_push(global.APPS, self)

	// Constants
	
	STORE_KEYS = undefined
	CACHE_KEYS = undefined


	// ABC

	static initialize = function() {
		// Prepare this app for operation
		self.STORE_KEYS = variable_struct_get_names(self.get_store())
		self.CACHE_KEYS = variable_struct_get_names(self.get_cache())
	}
	
	static start = function() {
		// Create store and cache for this particular singleton component

		var store = self.get_store()
		var cache = self.get_cache()

		if variable_struct_exists(global.store, self.name) {
			show_error("Store " + self.name + " already exists", true)
		}
		variable_struct_set(global.store, self.name, {})
		mutate(self, "start", store)

		if variable_struct_exists(global.cache, self.name) {
			show_error("Cache " + self.name + " already exists", true)
		}
		variable_struct_set(global.cache, self.name, {})
		remember(self, "start", cache)
	}

	static poststart = function() {
		// Run after entering component's room (if any)
	}


	// Storages

	static get_store = function() {
		return {}
	}
	
	static get_cache = function() {
		return {}
	}


	// Tests

	static get_testsuits = function() {
		return []
	}

	static get_fixtures = function() {
		return {}
	}
}
