class_name TelegramBot
extends Node

var polling_timer : Timer = Timer.new()

signal task_completed(result)

signal new_event(event)
signal get_updates(result)
signal message_send(result)

var _bot_token : String = ""
var _base_url : String = "https://api.telegram.org/bot{token}"

var _pooled_tasks : Array = []

var is_polling : bool
var last_update_id : int = -1


func _init(bot_token : String) -> void:
	_bot_token = bot_token
	_base_url = _base_url.format({token = _bot_token})
	set_name(bot_token)

func start_polling(interval : float) -> void:
	add_child(polling_timer)
	is_polling = true
	polling_timer.wait_time = interval
	polling_timer.connect("timeout", Callable(self, "_on_polling"))
	polling_timer.start()

func stop_polling() -> void:
	polling_timer.stop()
	polling_timer.disconnect("timeout", Callable(self, "_on_polling"))
	remove_child(polling_timer)

func do_get_updates() -> TelegramBotTask:
	var task : TelegramBotTask = TelegramBotTask.new()
	add_child(task)
	task.set_task(task.Methods.GET_UPDATES)
	task.connect("task_completed", Callable(self, "_on_task_completed").bind(task))
	_pooled_tasks.append(task)
	return task

func send_message(message : TelegramMessage) -> TelegramBotTask:
	var task : TelegramBotTask = TelegramBotTask.new()
	add_child(task)
	task.set_task(task.Methods.SEND_MESSAGE, message.to_dict(), ["Content-Type: application/json"])
	task.connect("task_completed", Callable(self, "_on_task_completed").bind(task))
	_pooled_tasks.append(task)
	return task

func _process(delta : float) -> void:
	if _pooled_tasks.size():
		var first_task : TelegramBotTask = _pooled_tasks.pop_front()
		first_task.process_task()

func _on_task_completed(result, task : TelegramBotTask) -> void:
	emit_signal("task_completed", result)
	
	match task.method:
		task.Methods.GET_UPDATES: 
			if is_polling:
				for update in result:
					var update_id : int = update.update_id
					if update_id > last_update_id:
						emit_signal("new_event", update)
						if last_update_id == -1 : last_update_id = update_id
						else: last_update_id += 1 
			else:
				emit_signal("get_updates", result)
		task.Methods.SEND_MESSAGE: emit_signal("message_send", result)


func _on_polling() -> void:
	do_get_updates()
