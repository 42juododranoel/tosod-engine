function test_application_storages() {
	start_application()

	assert(global.store, {})
	assert(global.cache, {})
	assert(global.idmap, {})
}


function test_application_constants() {
	start_application()

	assert(global.C.APPLICATION.NAME, "application")
	assert(global.C.APPLICATION.CACHE_KEYS, ["state"])
	assert(global.C.APPLICATION.STORE_KEYS, [])
}
