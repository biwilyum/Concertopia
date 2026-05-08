## oauth_server.gd  –  Autoload: OAuthServer
## Spins up a tiny TCP HTTP server on localhost:PORT for one request,
## captures ?code=… from the OAuth redirect, then shuts down.
extends Node

const PORT         : int    = 7123
const SUCCESS_HTML : String = """<!DOCTYPE html>
<html><head><meta charset='utf-8'>
<meta name='viewport' content='width=device-width, initial-scale=1'>
<style>
  body{margin:0;height:100vh;display:flex;align-items:center;justify-content:center;
       background:#0f0a23;font-family:sans-serif;color:#f5e9c4;}
  .card{text-align:center;padding:40px 60px;border-radius:20px;
        background:#1e1440;border:1px solid rgba(250,150,200,.25);
        box-shadow: 0 10px 30px rgba(0,0,0,0.5);}
  h2{margin:0 0 10px;font-size:28px;color:#f76fa0;}
  p{margin:0;opacity:.7;line-height:1.5;}
  .btn{margin-top:25px; display:inline-block; padding:12px 24px; border-radius:12px;
       background:#f76fa0; color:white; text-decoration:none; font-weight:bold;
       border:none; cursor:pointer; transition: transform 0.2s;}
  .btn:hover{transform: scale(1.05); background:#ff8fb7;}
</style>
<script>
  function closeWindow() {
    window.open('', '_self', '');
    window.close();
    // If window.close() fails, we just show a message.
    document.getElementById('status').innerText = 'You can now safely return to the app.';
    document.getElementById('close-btn').style.display = 'none';
  }
  window.onload = function() {
    setTimeout(closeWindow, 2000);
  };
</script>
</head>
<body><div class='card'>
  <h2>✓ Signed In!</h2>
  <p id='status'>Authentication successful. Returning to Concertopia...</p>
  <button id='close-btn' class='btn' onclick='closeWindow()'>Return to App Now</button>
  <p style='font-size:12px; margin-top:20px; opacity:0.4;'>This tab will try to close automatically.</p>
</div></body></html>"""

const ERROR_HTML : String = """<!DOCTYPE html>
<html><head><meta charset='utf-8'>
<meta name='viewport' content='width=device-width, initial-scale=1'>
<style>
  body{margin:0;height:100vh;display:flex;align-items:center;justify-content:center;
       background:#0f0a23;font-family:sans-serif;color:#f5e9c4;}
  .card{text-align:center;padding:40px 60px;border-radius:20px;
        background:#1e1440;border:1px solid rgba(250,100,100,.25);}
  h2{margin:0 0 10px;font-size:28px;color:#f76f6f;}
  p{margin:0;opacity:.7;}
  .btn{margin-top:25px; display:inline-block; padding:12px 24px; border-radius:12px;
       background:#444; color:white; text-decoration:none; font-weight:bold;
       border:none; cursor:pointer;}
</style></head>
<body><div class='card'>
  <h2>✗ Login Cancelled</h2>
  <p>The authentication process was interrupted.</p>
  <button class='btn' onclick='window.close()'>Close Tab</button>
</div></body></html>"""

signal oauth_code_received(code: String, state: String)
signal oauth_error(reason: String)

var _server    : TCPServer  = null
var _peer      : StreamPeerTCP = null
var _active    : bool       = false
var _buf       : String     = ""
var _expected_state : String = ""

# ── Public API ─────────────────────────────────────────────────────────────────

func start(expected_state: String) -> bool:
	stop()
	_server = TCPServer.new()
	var err : int = _server.listen(PORT, "127.0.0.1")
	if err != OK:
		push_error("OAuthServer: cannot listen on port %d – err %d" % [PORT, err])
		oauth_error.emit("Could not open local port %d. Another app may be using it." % PORT)
		return false
	_expected_state = expected_state
	_active         = true
	_buf            = ""
	set_process(true)
	return true

func stop() -> void:
	_active = false
	_peer   = null
	if _server != null:
		_server.stop()
		_server = null
	set_process(false)

# ── Process loop ───────────────────────────────────────────────────────────────

func _ready() -> void:
	set_process(false)

func _process(_delta: float) -> void:
	if not _active:
		return

	# Accept a new connection
	if _peer == null and _server != null and _server.is_connection_available():
		_peer = _server.take_connection()
		_buf  = ""

	if _peer == null:
		return

	# Read available bytes
	var available : int = _peer.get_available_bytes()
	if available > 0:
		var chunk : String = _peer.get_string(available)
		_buf += chunk

	if _buf.length() > 8192:
		_send_response(ERROR_HTML, 413)
		stop()
		oauth_error.emit("Payload too large. Connection closed.")
		return

	# Wait for end of HTTP headers
	if not "\r\n\r\n" in _buf and not "\n\n" in _buf:
		return

	# Parse the first request line: GET /callback?code=...&state=... HTTP/1.1
	var first_line : String = _buf.split("\n")[0].strip_edges()
	# e.g.  GET /?code=4%2F0A...&state=abc HTTP/1.1
	var parts := first_line.split(" ")
	if parts.size() < 2:
		_send_response(ERROR_HTML, 400)
		stop()
		oauth_error.emit("Malformed OAuth redirect.")
		return

	var path : String = parts[1]                # e.g. /?code=xxx&state=yyy
	var query : String = ""
	if "?" in path:
		query = path.split("?", true, 1)[1]

	var params : Dictionary = _parse_query(query)
	var code  : String  = params.get("code",  "")
	var state : String  = params.get("state", "")
	var error : String  = params.get("error", "")

	if not error.is_empty():
		_send_response(ERROR_HTML, 200)
		stop()
		oauth_error.emit("OAuth provider returned error: " + error)
		return

	if code.is_empty():
		_send_response(ERROR_HTML, 400)
		stop()
		oauth_error.emit("No authorisation code received.")
		return

	# State validation (CSRF protection)
	if state != _expected_state:
		_send_response(ERROR_HTML, 400)
		stop()
		oauth_error.emit("OAuth state mismatch – possible CSRF attempt.")
		return

	_send_response(SUCCESS_HTML, 200)
	stop()
	oauth_code_received.emit(code, state)

# ── Helpers ────────────────────────────────────────────────────────────────────

func _send_response(html: String, status: int) -> void:
	if _peer == null:
		return
	var status_text = "OK"
	if status == 400: status_text = "Bad Request"
	
	var html_bytes = html.to_utf8_buffer()
	var response_header : String = (
		"HTTP/1.1 %d %s\r\n" % [status, status_text] +
		"Content-Type: text/html; charset=utf-8\r\n" +
		"Content-Length: %d\r\n" % html_bytes.size() +
		"Connection: close\r\n" +
		"\r\n"
	)
	_peer.put_data(response_header.to_utf8_buffer())
	_peer.put_data(html_bytes)
	
	# Give the browser a moment to receive data before we close the peer
	await get_tree().create_timer(0.5).timeout
	_peer = null

func _parse_query(query: String) -> Dictionary:
	var result : Dictionary = {}
	if query.is_empty():
		return result
	for pair in query.split("&"):
		var kv := pair.split("=", true, 1)
		if kv.size() == 2:
			result[kv[0]] = kv[1].uri_decode()
	return result
