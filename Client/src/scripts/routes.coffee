angular.module('app').config ['$routeProvider', ($routeProvider) ->
	$routeProvider
	.when("/home",
		templateUrl: "views/home.html", reloadOnSearch: false
	)
	.when("/about",
		templateUrl: "views/about.html", reloadOnSearch: false
	)
	.otherwise
		redirectTo: '/home'
]
