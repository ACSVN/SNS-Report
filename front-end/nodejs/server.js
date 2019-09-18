var app = require('express')();
var server = require('http').Server(app);
var io = require('socket.io')(server);
var redis = require('redis');
 
server.listen(8890, function () {
  console.log('Server listening on port 8890!')
});

server.on('error', function(err){
	console.log('Server listen error: ' +  err.message);
});

io.on('connection', function (socket) {
	console.log("client connected");
	var redisClient = redis.createClient();
	redisClient.subscribe('message');

	redisClient.on("message", function(channel, data) {
		console.log("new percent add in queue "+ data['percent'] + " channel");
		socket.emit(channel, data);
	});

	socket.on('disconnect', function() {
		redisClient.quit();
	});

});
