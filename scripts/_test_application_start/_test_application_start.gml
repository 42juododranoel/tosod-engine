function get_application_start_testsuit() {
	return {
		name: "start",
		usefixutres: ["application_started"],
		tests: {
			set_application_storages: {
				test: function() {
					global.apps.application.start()
					
					assert(global.store.application, {})
					assert(global.cache.application, {state: undefined})
				}
			},
			//
			change_room: {
				test: function() {
					global.apps.application.start()

					on_room_start(function() {
						assert(room, room_application)
					})
				}
			}
			//
		}
	}
}
