extends SceneTree

func _init():
	print("Starting OAuthServer test...")
	var server = load("res://scripts/oauth_server.gd").new()
	# We need to add it to the tree or handle it manually because it uses _process
	root.add_child(server)
	
	var expected_state = "test_state_123"
	if not server.start(expected_state):
		print("FAILED: Could not start server")
		quit(1)
		return

	print("Server started on port 7123. Simulating request...")
	
	var client = StreamPeerTCP.new()
	var err = client.connect_to_host("127.0.0.1", 7123)
	if err != OK:
		print("FAILED: Could not connect to local server")
		quit(1)
		return
	
	# Wait for connection
	var timeout = 2.0
	while client.get_status() == StreamPeerTCP.STATUS_CONNECTING and timeout > 0:
		OS.delay_msec(100)
		timeout -= 0.1
	
	if client.get_status() != StreamPeerTCP.STATUS_CONNECTED:
		print("FAILED: Connection timeout")
		quit(1)
		return

	# Send GET request
	var request = "GET /?code=test_code&state=%s HTTP/1.1\r\nHost: localhost\r\n\r\n" % expected_state
	client.put_data(request.to_utf8_buffer())
	
	# Wait for response
	print("Request sent, waiting for response...")
	var response = ""
	timeout = 5.0
	while timeout > 0:
		if client.get_available_bytes() > 0:
			response += client.get_string(client.get_available_bytes())
			if "</html>" in response:
				break
		OS.delay_msec(100)
		timeout -= 0.1
		# Need to let the server process
		# server._process(0.1) - it's in the tree so it should process if we were in a main loop
		# Since we are in a script, we might need to wait or yield
	
	if response == "":
		print("FAILED: No response received")
		quit(1)
		return
	
	print("Received response:")
	# print(response) # Might be long
	
	if "HTTP/1.1 200 OK" in response:
		print("SUCCESS: Received 200 OK")
	else:
		print("FAILED: Did not receive 200 OK")
		print(response)
		quit(1)
		return

	# Check Content-Length
	var content_length_match = false
	var lines = response.split("\n")
	var declared_length = -1
	for line in lines:
		if line.to_lower().begins_with("content-length:"):
			declared_length = line.split(":")[1].strip_edges().to_int()
			content_length_match = true
			break
	
	if content_length_match:
		print("Found Content-Length: %d" % declared_length)
		var body = response.split("\r\n\r\n", true, 1)
		if body.size() > 1:
			var actual_body_size = body[1].to_utf8_buffer().size()
			print("Actual body size: %d" % actual_body_size)
			if declared_length == actual_body_size:
				print("SUCCESS: Content-Length matches actual body size")
			else:
				print("FAILED: Content-Length mismatch! Declared %d, actual %d" % [declared_length, actual_body_size])
				quit(1)
				return
		else:
			print("FAILED: Could not find body in response")
			quit(1)
			return
	else:
		print("FAILED: Content-Length header not found")
		quit(1)
		return

	if "window.close()" in response:
		print("SUCCESS: window.close() found in response")
	else:
		print("FAILED: window.close() NOT found in response")
		quit(1)
		return

	print("Test completed successfully!")
	quit(0)
