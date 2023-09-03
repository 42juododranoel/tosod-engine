function get_tosotest_syntax_testsuit() {
	return {
		name: "syntax",
		fixtures: {
			testsuit_fixture_1: function() {
				return "testsuit_fixture_1"
			},
		    testsuit_fixture_2: {
				depends: ["app_fixture_1", "testsuit_fixture_1"],
				fixture: function(fixtures) {
					return [fixtures.app_fixture_1, fixtures.testsuit_fixture_1]
				},
			},
		},
		tests: {
			parametrization: {
				parametrize: [
					["first", "second", "expected"],
					[
						[2, 2, 4],
					]
				],
				test: function(params) {
					var results = params.first + params.second
					
					assert(results, params.expected)
				},
			},
			//
			on_room_start_callback: {
				test: function() {
					on_room_start(function() {
						assert(room, room_tosotest)				
					})
				},
			},
			//
			app_fixture: {
				depends: ["app_fixture_2"],
				test: function(fixtures) {
					assert(fixtures.app_fixture_2, "app_fixture_1")				
				},
			},
			//			
			testsuit_fixture: {
				depends: ["testsuit_fixture_1"],
				test: function(fixtures) {
					assert(fixtures.testsuit_fixture_1, "testsuit_fixture_1")				
				},
			},
			//
			test_fixture: {
				fixtures: {
					test_fixture_1: function() {
						return "test_fixture_1"
					},
					test_fixture_2: {
						depends: ["test_fixture_1", "testsuit_fixture_2"],
						fixture: function(fixtures) {
							return [fixtures.test_fixture_1, fixtures.testsuit_fixture_2]
						},
					}
				},
				depends: ["app_fixture_1", "testsuit_fixture_1", "test_fixture_2"],
				test: function(fixtures) {
					assert(fixtures.test_fixture_2, ["test_fixture_1", ["app_fixture_1", "testsuit_fixture_1"]])
				},
			},
			//
			fixture_scopes: {
				fixtures: {
					test_fixture_1: function() {
						return "test_fixture_1"
					},
				},
				depends: ["app_fixture_1", "testsuit_fixture_1", "test_fixture_1"],
				test: function(fixtures) {
					assert(fixtures.app_fixture_1, "app_fixture_1")				
					assert(fixtures.testsuit_fixture_1, "testsuit_fixture_1")
					assert(fixtures.test_fixture_1, "test_fixture_1")
				},
			},
			//
		}
	}
}
