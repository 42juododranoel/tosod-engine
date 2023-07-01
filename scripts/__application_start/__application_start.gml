function start_application() {
	// Use this function to start application.
	// The application automatically starts menu after loading.

	
	// 1. Define constants

	// Here we include each app's constants.
	// All of them should be inside global.PURGABLE_GLOBALS.
	global.APPLICATION = get_application_constants()


	// 2. Define variables

	// Store is something you use to render everything on screen each frame.
	// You also save and load your game by saving and loading store.
	// Cache works the same way store does, but is 1) restorable and 2) non-serializable.
	// 1) Restorable means that it's OK to lose cache if something happens.
	// 2) Non-serializable means that you can store grid, object and other things in cache,
	// since the cache is not being saved or loaded, it simply keeps things in memory.
	// Idmap is a mapping between logical ids and runtime ids.
	// All stores got purged before each test.
	global.store = {}
	global.cache = {}
	global.idmap = {}


	// 3. Create component
	
	var store = get_application_store()
	var cache = get_application_cache()
	create_singleton(global.APPLICATION, store, cache)
	
	
	// 4. Run before switching room

	room_goto(room_application)
}


function poststart_application() {
	// 5. Run after switching room
	
	// application_start_menu()
}
