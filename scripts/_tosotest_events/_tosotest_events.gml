function on_room_start(callback) {
	global.tosotest.execution.has_callbacks = true
	variable_struct_set(
		global.tosotest.execution.callbacks, 
		global.tosotest.EVENTS.ROOM_START, 
		callback,
	)
}
