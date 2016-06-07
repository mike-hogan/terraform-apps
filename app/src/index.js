var express = require('express');
var app = express();

app.get('/', function (req, res) {
    console.log("Get a request to /");
    res.send('Hello World from Sample App 1.0!');
});

var port = 3000;
app.listen(port, function () {
    console.log('App listening on port ' + port);
});
