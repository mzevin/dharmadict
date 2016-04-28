var express = require('express');
var app = express();
var port = 3000;

var elasticsearch = require('elasticsearch');
var elasticClient = new elasticsearch.Client({
  host: 'localhost:9200',
  log: 'trace'});

app.configure(function(){
  app.use(express.static(__dirname));

  app.get('/api/terms', function(req, res) {
    elasticClient.search({
      index: "dharmadict",
      type: "terms",
      body: {
        query: {
          multi_match: {
            query: req.query.searchPattern,
            type: "most_fields",
            operator: "and",
            fields: [
              "wylie",
              "sanskrit",
              "translations.meanings.versions.rus",
              "subTerms.wylie",
              "subTerms.sanskrit",
              "subTerms.translations.meanings.versions.rus"
            ]
          }
        }
      }
    })
    .then(function(result){
      var r = result.hits.hits.map(function(e){
        return e._source;
      });
      res.json(r);
    });

  });
});

app.listen(port);
console.log('Listening on port ' + port);
