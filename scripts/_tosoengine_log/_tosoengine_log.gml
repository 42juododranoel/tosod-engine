function log(app, instance_id, message) {
	// Print storage debug transaction info
	
	if check_defined(instance_id) {
		print(app.name + "_" + string(instance_id) +  ":" + message)
	} else {
		print(app.name + ":" + message)
	}
}
