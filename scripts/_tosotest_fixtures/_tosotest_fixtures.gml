function tosotest_resolve_app_fixture(fixture, app_fixtures) {
	// Resolve app-level fixture, use another app fixtures for resolving, too
	
	var depends = []
	var body = fixture
	
	if not is_method(fixture) {
		body = fixture.fixture
		
		for (var fixture_index = 0; fixture_index < array_length(fixture.depends); fixture_index++) {
			var fixture_name = fixture.depends[fixture_index]
			var dependency_fixture = variable_struct_get(app_fixtures, fixture_name)
			var resolved_dependency_fixture = tosotest_resolve_app_fixture(dependency_fixture, app_fixtures)			
			array_push(depends, [fixture_name, resolved_dependency_fixture])
		}
	}
	
	return {
		depends: depends,
		fixture: body,
	}
}


function tosotest_resolve_testsuit_fixture(fixture, testsuit_fixtures) {
	// Resolve testsuit-level fixture, use app fixtures as fallbacks

	var depends = []
	var body = fixture

	if not is_method(fixture) {
		body = fixture.fixture
		
		for (var fixture_index = 0; fixture_index < array_length(fixture.depends); fixture_index++) {
			var fixture_name = fixture.depends[fixture_index]
			
			var dependency_fixture = variable_struct_getdefault(testsuit_fixtures, fixture_name, undefined)
			if not check_defined(dependency_fixture) {
				var resolved_dependency_fixture = variable_struct_get(global.tosotest.collection.app_fixture_graph, fixture_name)
			} else {
				var resolved_dependency_fixture = tosotest_resolve_testsuit_fixture(dependency_fixture, testsuit_fixtures)
			}

			array_push(depends, [fixture_name, resolved_dependency_fixture])
		}
	}

	return {
		depends: depends,
		fixture: body,
	}

}


function tosotest_resolve_test_fixture(fixture, testsuit_fixture_graph, test_fixtures) {
	// Resolve test-level fixture, use testsuit fixtures and app fixtures as fallbacks
	
	var depends = []
	var body = fixture

	if not is_method(fixture) {
		body = fixture.fixture
		
		for (var fixture_index = 0; fixture_index < array_length(fixture.depends); fixture_index++) {
			var fixture_name = fixture.depends[fixture_index]

			var dependency_fixture = variable_struct_getdefault(test_fixtures, fixture_name, undefined)
			if not check_defined(dependency_fixture) {
				var resolved_dependency_fixture = variable_struct_get(testsuit_fixture_graph, fixture_name)
				if not check_defined(resolved_dependency_fixture) {
					var resolved_dependency_fixture = variable_struct_get(global.tosotest.collection.app_fixture_graph, fixture_name)
				}			
			} else {
				var resolved_dependency_fixture = tosotest_resolve_test_fixture(dependency_fixture, testsuit_fixture_graph, test_fixtures)
			}

			array_push(depends, [fixture_name, resolved_dependency_fixture])
		}
	}

	return {
		depends: depends,
		fixture: body,
	}
}


function tosotest_resolve_apps_fixtures() {
	// Collect and resolve all apps fixtures

	var apps_fixtures = {}
	
	// Collect temporary fixture struct from each app fixtures
	var app_names = variable_struct_get_names(global.apps)
	for (var app_index = 0; app_index < array_length(app_names); app_index++) {
		var app_name = app_names[app_index]
		var app = variable_struct_get(global.apps, app_name)

		// Update app-level fixture collection
		var app_fixtures = app.get_fixtures()
		var app_fixture_names = variable_struct_get_names(app_fixtures)
		for (var fixture_index = 0; fixture_index < array_length(app_fixture_names); fixture_index++) {
			var fixture_name = app_fixture_names[fixture_index]
			var fixture = variable_struct_get(app_fixtures, fixture_name)
			variable_struct_set(apps_fixtures, fixture_name, fixture)
		}
	}

	// Resolve app-level fixture dependencies and make them globally-accessible
	var fixture_names = variable_struct_get_names(apps_fixtures)
	for (var fixture_index = 0; fixture_index < array_length(fixture_names); fixture_index++) {
		var fixture_name = fixture_names[fixture_index]
		var fixture = variable_struct_get(apps_fixtures, fixture_name)
		var resolved_fixture = tosotest_resolve_app_fixture(fixture, apps_fixtures)
		variable_struct_set(global.tosotest.collection.app_fixture_graph, fixture_name, resolved_fixture)
	}
}


function tosotest_resolve_app_testsuits_fixtures(app) {
	// Collect and resolve this app's fixtures from all testsuits

	var app_testsuit_fixtures_graph = {}
	variable_struct_set(global.tosotest.collection.testsuit_fixture_graph, app.name, app_testsuit_fixtures_graph)

	// For each testusit of this app's testsuits
	var app_testsuits = app.get_testsuits()
	for (var testsuit_index = 0; testsuit_index < array_length(app_testsuits); testsuit_index++) {
		var testsuit = app_testsuits[testsuit_index]()

		// Update global testsuit-level fixture collection
		var testsuit_fixtures = variable_struct_getdefault(testsuit, "fixtures", {})
		var testsuit_fixture_graph = {}
		var testsuit_fixture_names = variable_struct_get_names(testsuit_fixtures)
		for (var fixture_index = 0; fixture_index < array_length(testsuit_fixture_names); fixture_index++) {
			var fixture_name = testsuit_fixture_names[fixture_index]
			var fixture = variable_struct_get(testsuit_fixtures, fixture_name)
			var resolved_fixture = tosotest_resolve_testsuit_fixture(fixture, testsuit_fixtures)
			variable_struct_set(testsuit_fixture_graph, fixture_name, resolved_fixture)
		}
		variable_struct_set(app_testsuit_fixtures_graph, testsuit.name, testsuit_fixture_graph)
	}
}
