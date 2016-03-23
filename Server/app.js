var express = require('express');
var app = express();
var port = 3000

app.configure(function(){
  app.use(express.static(__dirname));
});

app.listen(port);
console.log('Listening on port ' + port);
