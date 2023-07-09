function EngineApp(): App("engine") constructor {
	// ABC
	
	static start = function() {
		// 1. Define constants

		global.TOSOTEST = new TosotestApp()
		global.APPLICATION = new ApplicationApp()

		for (var app_index = 0; app_index < array_length(global.APPS); app_index++) {
			var app = global.APPS[app_index]
			app.initialize()
		}


		// 2. Define variables

		// Store is something you use to render everything on screen each frame.
		// You also save and load your game by saving and loading store.
		// Cache works the same way store does, but is 1) restorable and 2) non-serializable.
		// 1) Restorable means that it's OK to lose cache if something happens.
		// 2) Non-serializable means that you can store grid, object and other things in cache,
		// since the cache is not being saved or loaded, it simply keeps things in memory.
		// Idmap is a mapping between logical ids and runtime ids.
		// All stores get purged before each test.
		global.store = {}
		global.cache = {}
		global.idmap = {}


		// 3. Create storages


		// 4. Run component
	
		if debug_mode {
			// Run tests
			global.TOSOTEST.start()
		} else {
			// Run game
			global.APPLICATION.start()
		}
	}


	// Tests

	static get_testsuits = function() {
		return [
			get_engine_start_testsuit,
			get_engine_room_creation_code_testsuit,
		]
	}
}
