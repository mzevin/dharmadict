angular.module('app')

.factory('termsResource',
	['$resource', ($resource) ->
		$resource 'api/terms/:id', {}, {
			get: { method: 'GET' }
			list: { method: 'GET', isArray: true }
		}
	])
