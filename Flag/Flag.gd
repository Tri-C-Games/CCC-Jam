extends Area2D

func _on_Flag_body_entered(_body):
	$"Win SFX".play()
	yield($"Win SFX", "finished")
	global.go_to_next_level(true)
