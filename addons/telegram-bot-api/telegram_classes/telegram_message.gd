class_name TelegramMessage
extends RefCounted

enum ParseModes {
	NONE,
	MARKDOWN,
	MARKDOWNv2,
	HTML
}

var chat_id : String
var text : String
var parse_mode : String
var entities : Array
var disable_web_page_preview : bool
var disable_notification : bool
var reply_to_message_id : int
var allow_sending_without_reply : int
var reply_markup : Dictionary

func _init(_chat_id : String , _text : String, _parse_mode : int = -1, _entities : Array = [], _disable_web_page_preview : bool = false, _disable_notification : bool = false, _reply_to_message_id : int = 0, _allow_sending_without_reply : bool = false, _reply_markup : Dictionary = {}) -> void:
	chat_id = _chat_id
	text = _text
	parse_mode = return_parsemode(_parse_mode)
	entities = _entities
	disable_web_page_preview = _disable_web_page_preview
	disable_notification = _disable_notification
	reply_to_message_id = _reply_to_message_id
	allow_sending_without_reply = _allow_sending_without_reply
	reply_markup = _reply_markup

func return_parsemode(_parse_mode : int) -> String:
	match _parse_mode:
		ParseModes.MARKDOWN: return "Markdown"
		ParseModes.MARKDOWNv2: return "MarkdownV2"
		ParseModes.HTML: return "HTML"
		_: return ""

func to_dict() -> Dictionary:
	return {
		chat_id = chat_id,
		text = text,
		parse_mode = parse_mode,
		entities = entities,
		disable_web_page_preview = disable_web_page_preview,
		disable_notification = disable_notification,
		reply_to_message_id = reply_to_message_id,
		allow_sending_without_reply = allow_sending_without_reply,
		reply_markup = reply_markup
	}
