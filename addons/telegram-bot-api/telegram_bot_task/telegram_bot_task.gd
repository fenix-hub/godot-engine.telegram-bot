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
var _header : PoolStringArray
var _payload : Dictionary

var method : int

func _ready() -> void:
    connect("request_completed", self, "_on_task_completed")

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

func set_task(_method : int, payload : Dictionary = {}, header : PoolStringArray = []) -> void:
    _base_url = get_parent()._base_url
    match_endpoint(_method)
    _header = header
    _payload = payload

func process_task() ->  void:
    request(_base_url + _endpoint, _header, true, _http_method, to_json(_payload))

func _on_task_completed(result : int, response_code : int, headers : PoolStringArray, body : PoolByteArray):
    if result == 0:
        if response_code == 200:
            var result_body = parse_json(body.get_string_from_utf8()).result
            emit_signal("task_completed", result_body)
            queue_free()
