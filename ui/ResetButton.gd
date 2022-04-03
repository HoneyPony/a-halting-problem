extends Button

func _on_pressed():
	GS.scene_change.change(GS.current_level)
