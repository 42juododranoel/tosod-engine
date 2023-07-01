function test_start_application_set_global_storages() {
	start_application()

	assert(global.store)
	assert(global.cache)
	assert(global.idmap)
}


function test_start_application_set_global_constants() {
	start_application()
	
	assert(global.APPLICATION)
}


function test_start_application_set_application_storages() {
	start_application()
	
	assert(global.store.application, {})
	assert(global.cache.application, {state: undefined})
}


function test_start_application_set_application_constants() {
	start_application()

	assert(global.APPLICATION.NAME, "application")
	assert(global.APPLICATION.CACHE_KEYS, ["state"])
	assert(global.APPLICATION.STORE_KEYS, [])
}
