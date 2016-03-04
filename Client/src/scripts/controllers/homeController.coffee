angular.module('app')
	.controller('homeController', [
		'$scope', '$log', 'termsService'
		($scope, console, termsService) ->

			$scope.showAboutInfo = false;
			$scope.searchPattern = ""
			$scope.terms = []
			$scope.currentTerm = null

			$scope.search = () ->
				termsService.search	(res) ->
					$scope.showAboutInfo = false
					$scope.terms = res

			$scope.showTerm = (id) ->
				$scope.currentTerm =  (t for t in $scope.terms when t.id == id)[0]

			$scope.toggleAbout = () ->
				$scope.showAboutInfo = not $scope.showAboutInfo
	])
