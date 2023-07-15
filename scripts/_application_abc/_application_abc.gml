function ApplicationApp(): App("application") constructor {
	// Constants

	STATES = {
		MENU: "menu",
		GAME: "game",
	}

	SCREEN_WIDTH = 1536
	SCREEN_HEIGHT = 864
	FRAME_RATE = 60


	// ABC
	
	static run_component = function() {
		room_goto(room_application)
	}
	

	// Storages

	static get_cache = function() {
		return {
			state: undefined,
		}
	}
	
	
	// Tests
	
	static get_testsuits = function() {
		return [
			get_application_start_testsuit,
		]
	}


	static get_fixtures = function() {
		return {
			application_started: {
				fixture: function() {
					global.apps.application.start()
				},
			}
		}
	}
}
