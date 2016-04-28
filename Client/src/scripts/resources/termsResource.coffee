angular.module('app')

.factory('termsResource',
	['$resource', ($resource) ->
		$resource 'api/terms/:pattern', {}, {
			get: { method: 'GET' }
			search: { method: 'GET', params: {pattern: '@searchPattern'}, isArray: true }
		}
	])
