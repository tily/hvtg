express = require 'express'
request = require 'request'
app = express()

app.set 'port', process.env.PORT || 5000
app.use express.static(__dirname + '/public', index: 'client.html')

app.get '/image.png', (req, res)->
  req.pipe(request(req.query.url)).pipe(res)

app.listen app.get 'port'
