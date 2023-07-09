function get_application_start_testsuit() {
	return {
		name: "start",
		usefixutres: ["application_started"],
		tests: {
			set_application_storages: {
				test: function() {
					global.APPLICATION.start()
					
					assert(global.store.application, {})
					assert(global.cache.application, {state: undefined})
				}
			},
			//
		}
	}
}
