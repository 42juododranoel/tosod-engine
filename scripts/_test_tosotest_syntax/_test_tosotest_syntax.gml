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
		}
	}
}
