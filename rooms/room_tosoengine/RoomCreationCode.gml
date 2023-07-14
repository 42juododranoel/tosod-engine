// Create tosoengine and tosotest and run everything
global.tosoengine = new TosoengineApp()
global.tosotest = new TosotestApp()

// Initialize apps mapping
global.apps = {
	tosoengine: global.tosoengine,
	tosotest: global.tosotest,
}

// This is where the fun begins (c)
global.tosoengine.start()
