function get_engine_room_creation_code_testsuit() {
	return {
		name: "room_creation_code",
		tests: {
			set_apps: {
				test: function() {
					assert(global.ENGINE)
					assert(global.APPS)
				},
			},
			//
		}
	}
}
