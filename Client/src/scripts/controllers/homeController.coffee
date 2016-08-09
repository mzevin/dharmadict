angular.module('app')
	.controller('homeController', [
		'$scope', '$log', 'termsService'
		($scope, console, termsService) ->

			$scope.showEnglish = true
			$scope.showAboutInfo = false
			$scope.searchPattern = ""
			$scope.terms = []
			$scope.currentTerm = null

			$scope.search = () ->
				$scope.showAboutInfo = false
				$scope.currentTerm = null
				termsService.search($scope.searchPattern, (resp) ->
						$scope.terms = resp
						$scope.currentTerm = $scope.terms[0] if $scope.terms.length == 1
				)

			$scope.showTerm = (idx) ->
				$scope.currentTerm =  $scope.terms[idx]

			$scope.toggleAboutInfo = () ->
				$scope.showAboutInfo = not $scope.showAboutInfo

			$scope.toggleComment = (tIdx, mIdx) ->
				idSelector = "#comment-#{tIdx}-#{mIdx}"
				if $(idSelector).hasClass("hidden") then $(idSelector).removeClass("hidden") else $(idSelector).addClass("hidden")
				return

			$scope.getTranslator = (id) ->
				switch id
					when "MK" then "М.Н. Кожевникова"
					when "AKT" then "А. Кугявичус - А.А. Терентьев"
					when "ZAG" then "Б.И. Загуменнов"
					when "DON" then "А.М. Донец"
					when "HOP" then "J. Hopkins"
					when "BRZ" then "A. Berzin"
					else "UNKNOWN"

			$scope.byLang = (translation) ->
				translation.language == "rus" || $scope.showEnglish
	])
