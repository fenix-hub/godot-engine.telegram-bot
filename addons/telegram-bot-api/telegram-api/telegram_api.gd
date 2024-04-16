extends Node


func _ready():
	pass

func get_bot(token : String) -> TelegramBot:
	var bot : TelegramBot = TelegramBot.new(token)
	add_child(bot)
	return bot
