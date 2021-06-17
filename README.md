# godot-engine.telegram-bot-api
A GDScript addon to interact with a Telegram Bot in Godot Engine.

```gdscript
extends Node

func _ready():
    var bot : TelegramBot = TelegramAPI.get_bot("<YOUR BOT TOKEN>")
    bot.connect("new_event", self, "_on_bot_event")
    bot.start_polling(1.0)
    bot.send_message(TelegramMessage.new("<CHAT ID>", "_Test Message_", TelegramMessage.ParseModes.MARKDOWN))

func _on_bot_event(event : Dictionary) -> void:
    print(event)
```
