function get_tosotest_syntax_testsuit() {
	return {
		name: "syntax",
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
		}
	}
}
