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
	
	static super_start = start
	static start = function() {
		// Use this function to start application.
		// The application automatically starts menu after loading.

	
		// 1. Define constants


		// 2. Define variables


		// 3. Create storages
	
		super_start()

	
		// 4. Run before switching room

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
					global.APPLICATION.start()
				},
			}
		}
	}
}
