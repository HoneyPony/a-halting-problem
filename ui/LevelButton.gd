extends Button

export var index = 0

func _on_pressed():
	var scene = GS.levels[index]
	GS.current_level = scene
	
	GS.scene_change.change(GS.current_level)
