function TosoengineApp(): App("tosoengine") constructor {
	// Constants
	
	// Keys are used to validate remember() and mutate() call payloads.
	STORE_KEYS = {}
	CACHE_KEYS = {}


	// ABC

	static set_constants = function() {
		// Set apps
		global.apps.application = new ApplicationApp()

		// Set STORE_KEYS and CACHE_KEYS for apps
		var app_names = variable_struct_get_names(global.apps)
		for (var app_index = 0; app_index < array_length(app_names); app_index++) {			
			var app_name = app_names[app_index]
			var app = variable_struct_get(global.apps, app_name)
			
			var app_store_keys = variable_struct_get_names(app.get_store())
			variable_struct_set(self.STORE_KEYS, app_name, app_store_keys)

			var app_cache_keys = variable_struct_get_names(app.get_cache())
			variable_struct_set(self.CACHE_KEYS, app_name, app_cache_keys)
		}
	}

	static set_variables = function() {
		// Set storages
		global.store = {}
		global.cache = {}
		global.idmap = {}
	}

	static run_component = function() {
		if debug_mode {
			// Run tests
			global.tosotest.start()
		} else {
			// Run game
			global.apps.application.start()
		}
	}


	// Tests

	static get_testsuits = function() {
		return [
			get_tosoengine_start_testsuit,
			get_tosoengine_room_creation_code_testsuit,
		]
	}
}
