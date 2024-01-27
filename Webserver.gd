extends Node

@export var subViewport: SubViewport
@export var port: int = 6969
@export var address: String = "0.0.0.0"

var server: TCPServer
var clients: Array[StreamPeerTCP]
var activeStreams: Array[bool]
var img: Image
var buffer: PackedByteArray

# Stop the server
func stop():
	for client in clients:
		client.disconnect_from_host()
	clients.clear()
	activeStreams.clear()
	server.stop()
	set_process(false)

# Parse the request string
func parseRequest(request_string: String) -> Array[String]:
	var request = request_string.split(" ")
	var method = request[0]
	var path = request[1]
	var version = request[2]
	return [method, path, version]
	
# Thread to send data to not bog down main
func sendThread(client):
	while client.get_status() == StreamPeerTCP.STATUS_CONNECTED:
		client.put_data(("--frame\r\nContent-Type: image/jpeg\r\nContent-Length: %d\r\n\r\n" % [buffer.size()]).to_utf8_buffer() + buffer + "\r\n\r\n".to_utf8_buffer())
		OS.delay_msec(33)
		
# Called when the node enters the scene tree for the first time.
func _ready():
	server = TCPServer.new()
	var err: int = server.listen(port, address)
	set_process(true)
	match err:
		22:
			print_debug("Could not bind to port %d, already in use" % [port])
			stop()
		_:
			print_debug("HTTP Server listening on http://%s:%s" % [address, port])
			Core.visionStreamUp = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if server:
		if activeStreams.any(func(x): return x):
			img = subViewport.get_texture().get_image()
			buffer = img.save_jpg_to_buffer()
		
		var new_client = server.take_connection()
		if new_client:
			clients.append(new_client)
			activeStreams.append(false)
			
		for clientIdx in range(len(clients) - 1, -1, -1):
			var client = clients[clientIdx]
			if client.get_status() == StreamPeerTCP.STATUS_CONNECTED:
				if activeStreams[clientIdx]: continue
				
				var bytes = client.get_available_bytes()
				if bytes > 0:
					var parsedRequest = parseRequest(client.get_string(bytes))
					var method = parsedRequest[0]
					var path = parsedRequest[1]
						
					if method == "GET" && path == "/":
						client.put_string("HTTP/1.1 200 OK\r\nServer: Godot\r\nConnection: close\r\nContent-Type: multipart/x-mixed-replace;boundary=frame\r\n\r\n")
						activeStreams[clientIdx] = true
						
						var thread = Thread.new()
						thread.start(sendThread.bind(client))
					else:
						client.put_string("HTTP/1.1 404\r\nContent-Length: 0")
			else:
				clients.remove_at(clientIdx)
				activeStreams.remove_at(clientIdx)
