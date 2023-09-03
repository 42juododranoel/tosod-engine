function get_application_start_testsuit() {
	return {
		name: "start",
		tests: {
			set_application_storages: {
				depends: ["application_started"],
				test: function() {
					assert(global.store.application, {})
					assert(global.cache.application, {state: undefined})
				}
			},
			//
			change_room: {
				depends: ["application_started"],
				test: function() {
					on_room_start(function() {
						assert(room, room_application)
					})
				}
			}
			//
		}
	}
}
