extends ColorRect

signal finished

onready var rich_text_label = get_node("ColorRect/RichTextLabel")
onready var increment_timer = get_node("Increment Visible Characters Timer")
onready var next_dialogue_timer = get_node("Next Dialogue Timer")
onready var stop_timer = get_node("Stop Dialogue Timer")
onready var key_press_sfx = get_node("Key Press SFX")
onready var bridge = preload("res://World/Tutorial/Bridge/Bridge.tscn").instance()

var dialogue_buffer = []

var pausing_punctuation = {
	"." : 0.5,
	"!" : 0.5,
	"?" : 0.5,
	"," : 0.2
}

func buffer_dialogue(text):
	dialogue_buffer.append(text)

func start_dialogue():
	rich_text_label.text = dialogue_buffer[0]
	rich_text_label.visible_characters = 0
	visible = true
	increment_timer.start()

func _on_Increment_Visible_Characters_Timer_timeout():
	if rich_text_label.visible_characters == rich_text_label.get_total_character_count():
		dialogue_buffer.erase(dialogue_buffer[0])
		
		if dialogue_buffer.size() == 0:
			stop_dialogue()
		else:
			increment_timer.paused = true
			next_dialogue_timer.start()
	else:
		rich_text_label.visible_characters += 1
		key_press_sfx.play()
		var new_char = rich_text_label.text[rich_text_label.visible_characters - 1]
		
		if new_char in pausing_punctuation.keys():
			pause_typing(pausing_punctuation[new_char])

func pause_typing(duration):
	# Duration is in seconds.
	increment_timer.paused = true
	yield(get_tree().create_timer(duration), "timeout")
	increment_timer.paused = false

func _on_Next_Dialogue_Timer_timeout():
	set_next_dialogue()

func set_next_dialogue():
	increment_timer.paused = false
	rich_text_label.text = dialogue_buffer[0]
	rich_text_label.visible_characters = 0

func stop_dialogue():
	increment_timer.stop()
	stop_timer.start()

func kill_dialogue():
	visible = false
	increment_timer.stop()
	next_dialogue_timer.stop()
	stop_timer.stop()
	emit_signal("finished")
	get_parent().get_parent().get_parent().get_node("BridgePosition").add_child(bridge)

func _on_Stop_Dialogue_Timer_timeout():
	kill_dialogue()

func _on_Button_pressed():
	if rich_text_label.visible_characters == rich_text_label.get_total_character_count():
		if dialogue_buffer.size() == 0:
			kill_dialogue()
		else:
			set_next_dialogue()
	else:
		rich_text_label.visible_characters = rich_text_label.get_total_character_count()
		key_press_sfx.play()
