extends ColorRect

onready var rich_text_label = get_node("ColorRect/RichTextLabel")
onready var increment_timer = get_node("Increment Visible Characters Timer")
onready var pause_timer = get_node("Typing Pause Timer")
var dialog_buffer=[]

var sentence_ending_punctuation = [".", "!", "?"]

func start_dialogue(text):
	rich_text_label.text = text
	rich_text_label.visible_characters = 0
	visible = true
	increment_timer.start()

func _on_Increment_Visible_Characters_Timer_timeout():
	rich_text_label.visible_characters += 1
	get_parent().play_key_press_sfx()
	var new_char = rich_text_label.text[rich_text_label.visible_characters - 1]
	
	if rich_text_label.visible_characters == rich_text_label.get_total_character_count():
		stop_incrementing()
		return
	
	if new_char in sentence_ending_punctuation:
		pause_typing(0.5)

func pause_typing(duration):
	# Duration is in seconds.
	increment_timer.stop()
	pause_timer.wait_time = duration
	pause_timer.start()

func buffer_dialogue(text):
	dialog_buffer.push_back(text)

func _on_Typing_Pause_Timer_timeout():
	increment_timer.start()

func stop_incrementing():
	$"Increment Visible Characters Timer".stop()
	$"Disappear Timer".start()

func _on_Disappear_Timer_timeout():
	visible = false
	if dialog_buffer:
		start_dialogue(dialog_buffer[0])
		dialog_buffer.erase(dialog_buffer[0])
