function start_application() {
	// Use this function to start application.
	// The application automatically starts menu after loading.
	
	// 1. Create component
	create_application()

	
	// 2a. Run component (switch room)

	room_goto(room_application)
}


function poststart_application() {
	// 2b. Run component (object created)
	
	// application_start_menu()
}
