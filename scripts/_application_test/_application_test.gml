function test_application_storages() {
	start_application()

	assert(global.store, {})
	assert(global.cache, {})
	assert(global.idmap, {})
}


function test_application_constants() {
	start_application()

	assert(global.APPLICATION.NAME, "application")
	assert(global.APPLICATION.CACHE_KEYS, ["state"])
	assert(global.APPLICATION.STORE_KEYS, [])
}
