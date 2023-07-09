function get_engine_start_testsuit() {
	return {
		name: "start",
		tests: {
			set_apps: {
				test: function() {
					assert(global.APPS, [
						global.ENGINE,
						global.TOSOTEST,
						global.APPLICATION,						
					])
				},
			},
			//
			set_constants: {
				test: function() {
					assert(global.TOSOTEST)
					assert(global.APPLICATION)
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
