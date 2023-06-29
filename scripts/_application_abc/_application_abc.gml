function get_application_constants() {
	return {
		CACHE_KEYS: variable_struct_get_names(get_application_cache()),
		STORE_KEYS: variable_struct_get_names(get_application_store()),
		NAME: "application",
		//
		STATES: {
			MENU: "menu",
			GAME: "game",
		},
		//
		SCREEN_WIDTH: 1536,
		SCREEN_HEIGHT: 864,
		FRAME_RATE: 60,
	}
}


function get_application_store() {
	return {}
}


function get_application_cache() {
	return {
		state: undefined,
	}
}
