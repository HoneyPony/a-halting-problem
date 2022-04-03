extends Node

func _ready():
	var button = get_parent()
	button.connect("pressed", self, "_on_pressed")
	button.connect("mouse_entered", self, "on_over")
	
func _on_pressed():
	SFX.button_press.play_sfx()

func on_over():
	SFX.button_highlight.play_sfx()
