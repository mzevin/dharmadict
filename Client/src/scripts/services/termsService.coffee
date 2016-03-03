angular.module('app').service('termsService', [
	'termsResource', (termsResource) ->

		search: (callback) ->
			termsResource.list {}, (response) ->
				callback(response)
])
