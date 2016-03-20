angular.module('app')
	.controller('homeController', [
		'$scope', '$log', 'termsService', 'elasticService'
		($scope, console, termsService, elasticService) ->

			$scope.showAboutInfo = false
			$scope.searchPattern = ""
			$scope.terms = []
			$scope.currentTerm = null

			$scope.search = () ->
				$scope.showAboutInfo = false
				elasticService.search(
					index: "dharmadict"
					type: "terms"
					body:
						query:
							match:
								wylie: "#{$scope.searchPattern}"
				).then(
					(resp) ->
						$scope.terms = (hit._source for hit in resp.hits.hits)
					,
					(err) ->
						console.trace(err.message)
				)
			$scope.showTerm = (idx) ->
				$scope.currentTerm =  $scope.terms[idx]

			$scope.toggleAbout = () ->
				$scope.showAboutInfo = not $scope.showAboutInfo
	])
