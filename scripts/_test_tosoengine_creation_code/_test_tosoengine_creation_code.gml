function get_tosoengine_room_creation_code_testsuit() {
	return {
		name: "room_creation_code",
		tests: {
			set_apps: {
				test: function() {
					assert(global.apps)
				},
			},
			//
			create_tosoengine: {
				test: function() {
					assert(global.tosoengine)
				},
			},
			//
			create_tosotest: {
				test: function() {
					assert(global.tosotest)
				},
			},
			//
		}
	}
}
