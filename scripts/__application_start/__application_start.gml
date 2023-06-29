function start_application() {
	// Your game entrypoint.
	// Call this function in game start event handler of object_application.
	
	
	// 1. Create component
	create_application()

	
	// 2a. Run component (switch room)

	room_goto(room_application)
}


function poststart_application() {
	// 2b. Run component (object created)
	
	// application_start_menu()
}
