function get_tosoengine_start_testsuit() {
	return {
		name: "start",
		tests: {
			set_apps: {
				test: function() {
					assert(global.apps.application)
					assert(global.apps.tosoengine)
					assert(global.apps.tosotest)
				},
			},
			//
			set_store_keys: {
				test: function() {
					assert(global.tosoengine.STORE_KEYS.tosoengine, [])
					assert(global.tosoengine.STORE_KEYS.tosotest, [])
					assert(global.tosoengine.STORE_KEYS.application, [])
					assert(array_length(variable_struct_get_names(global.tosoengine.STORE_KEYS)), 3)
				},
			},
			//
			set_cache_keys: {
				test: function() {
					assert(global.tosoengine.CACHE_KEYS.tosoengine, [])
					assert(global.tosoengine.CACHE_KEYS.tosotest, [])
					assert(global.tosoengine.CACHE_KEYS.application, ["state"])
					assert(array_length(variable_struct_get_names(global.tosoengine.CACHE_KEYS)), 3)
				},
			},
			//
			set_storages: {
				test: function() {
					assert(global.store, {})
					assert(global.cache, {})
					assert(global.idmap, {})
				},
			},
		}
	}
}
