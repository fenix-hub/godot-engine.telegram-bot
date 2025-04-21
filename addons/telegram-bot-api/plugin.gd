@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_autoload_singleton("TelegramAPI", "res://addons/telegram-bot-api/telegram-api/telegram_api.gd")

func _exit_tree() -> void:
	remove_autoload_singleton("TelegramAPI")
