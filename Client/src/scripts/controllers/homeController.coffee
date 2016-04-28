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
				$scope.currentTerm = null
				elasticService.search(
					index: "dharmadict"
					type: "terms"
					body:
						query:
							multi_match:
								query: $scope.searchPattern
								type: "most_fields"
								operator: "and"
								fields: [
									"wylie"
									"sanskrit"
									"translations.meanings.versions.rus"
									"subTerms.wylie"
									"subTerms.sanskrit"
									"subTerms.translations.meanings.versions.rus"
								]
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

			$scope.toggleComment = (tIdx, mIdx) ->
				idSelector = "#comment-#{tIdx}-#{mIdx}"
				if $(idSelector).hasClass("hidden") then $(idSelector).removeClass("hidden") else $(idSelector).addClass("hidden")
				return
			###
			$scope.showComment = (tIdx, mIdx) ->
				$("#comment-#{tIdx}-#{mIdx}").removeClass("hidden")
				return

			$scope.hideComment = (tIdx, mIdx) ->
				$("#comment-#{tIdx}-#{mIdx}").addClass("hidden")
				return
			###
	])
