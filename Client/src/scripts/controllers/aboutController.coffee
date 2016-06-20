angular.module('app')
	.controller('homeController', [
		'$scope', '$log'
		($scope, console) ->
		    console.log("about");
	])
