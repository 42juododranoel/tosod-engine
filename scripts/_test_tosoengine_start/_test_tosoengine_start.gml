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
					var store_keys = variable_struct_get_names(global.tosoengine.STORE_KEYS)
					assert(store_keys, ["tosoengine", "application", "tosotest"])
				},
			},
			//
			set_cache_keys: {
				test: function() {
					var cache_keys = variable_struct_get_names(global.tosoengine.CACHE_KEYS)
					assert(cache_keys, ["tosoengine", "application", "tosotest"])
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
