class_name TelegramBotTask
extends HTTPRequest

signal task_completed(result)

enum Methods {
	GET_UPDATES,
	SEND_MESSAGE
}

var _base_url : String
var _endpoint : String
var _http_method : int
var _header : PackedStringArray
var _payload : Dictionary

var method : int

func _ready() -> void:
	connect("request_completed", Callable(self, "_on_task_completed"))

func match_endpoint(_method : int) -> void:
	method = _method
	match method:
		Methods.GET_UPDATES:
			_endpoint =  "/getUpdates"
			_http_method = HTTPClient.METHOD_GET
		Methods.SEND_MESSAGE:
			_endpoint = "/sendMessage"
			_http_method = HTTPClient.METHOD_POST
		_:
			_http_method = HTTPClient.METHOD_GET
			_endpoint = ""

func set_task(_method : int, payload : Dictionary = {}, header : PackedStringArray = []) -> void:
	_base_url = get_parent()._base_url
	match_endpoint(_method)
	_header = header
	_payload = payload

func process_task() ->  void:
	request(_base_url + _endpoint, _header, _http_method, JSON.new().stringify(_payload))

func _on_task_completed(result : int, response_code : int, headers : PackedStringArray, body : PackedByteArray):
	if result == 0:
		if response_code == 200:
			var test_json_conv = JSON.new()
			var error = test_json_conv.parse(body.get_string_from_utf8())
			if error == OK: 
				var result_body = test_json_conv.get_data().result
				emit_signal("task_completed", result_body)
				queue_free()
