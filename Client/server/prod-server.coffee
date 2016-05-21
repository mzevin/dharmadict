express = require 'express'
app = express()
port = 3000

elasticsearch = require 'elasticsearch'
elasticClient = new elasticsearch.Client
	host: 'localhost:9200'
	log: 'info'

app.configure () ->
	app.use(express.static(__dirname))

	app.get '/api/terms', (req, res) ->
		elasticClient.search
			index: "dharmadict"
			type: "terms"
			body:
				query:
					multi_match:
						query: req.query.searchPattern
						type: "most_fields"
						operator: "and"
						fields: [
							"wylie"
							"sanskrit_rus"
							"sanskrit_eng"
							"translations.meanings.versions.rus"
						]
		.then (result) ->
			res.json (hit._source for hit in result.hits.hits)
	return

app.listen port
console.log 'Listening on port ' + port
