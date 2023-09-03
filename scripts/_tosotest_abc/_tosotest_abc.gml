function TosotestApp(): App("tosotest") constructor {
	// Constants

	STATUSES = {
		FAIL: 0,
		OK: 1,
	}
	
	EVENTS = {
		ROOM_START: "room_start",
	}	
	
	// Exist debug mode on first failing test
	EXITFIRST = false


	// Variables
	
	collection = {
		// Each test and parametrized signature is saved here
		signatures: [],
		// Fixture section
		app_fixture_graph: {},
		testsuit_fixture_graph: {},
		// Statistics are used for informational UX purposes
		statistics: {
			app_count: 0,
			testsuit_count: 0,
			test_count: 0,
		},
	}
	
	execution = {
		// Callbacks are run by object_tosotest, whose id is stored here,
		// and is updated before each test thanks to room_tosotest's creation code
		object_id: undefined,
		// Signature index is an index of currently running test in the collection
		signature_index: 0,
		// Callbacks are run during events by object_tosotest,
		// they are needed to postpone asserts until a specific event occurs
		callbacks: {},
		// Results store signature run results
		results: {},
		// Statistics are used for informational UX purposes
		statistics: {
			total: 0,
			passed: 0,
			failed: 0,
		}
	}
	
	
	// ABC
	
	static set_variables = function() {
		tosotest_collect()
	}
	
	static run_component = function() {
		// Start testing
		
		print()
		print("Running tests...")		
		room_goto(room_tosotest)
	}


	// Tests

	static get_testsuits = function() {
		return [
			get_tosotest_syntax_testsuit,
		]
	}

	static get_fixtures = function() {
		return {
			app_fixture_1: function() {
				return "app_fixture_1"
			},
		    app_fixture_2: {
				depends: ["app_fixture_1"],
				fixture: function(fixtures) {
					return fixtures.app_fixture_1
				}
			}
		}
	}
}
