function create_application() {
	// Constants
	// 
	// Here we include each app's constants.
	// Struct C is used to make it easier to purge globals in tests.

	global.APPLICATION = get_application_constants()


	// Storages
	// 
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
	

	// Components

	var store = get_application_store()
	var cache = get_application_cache()
	//create_singleton(global.APPLICATION, store, cache)
}
