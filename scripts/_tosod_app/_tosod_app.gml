function App(_name) constructor {
	name = _name


	// ABC

	static set_constants = function() {
	
	}

	static set_variables = function() {
	
	}

	static set_storages = function() {
		// Set store and cache in global namespace, if not already set.
		
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

	static run_component = function() {
		// Run code after all setup is done.
	}

	static postrun_component = function() {
		// Run code after entering component's room.
	}

	static start = function() {
		// Create store and cache for this particular component, if singleton.

		self.set_constants()
		self.set_variables()
		self.set_storages()
		self.run_component()
	}

	static poststart = function() {
		// Run after entering component's room, if singleton and has one.
		
		self.postrun_component()
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
