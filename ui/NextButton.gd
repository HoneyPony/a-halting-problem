extends Button

func _on_pressed():
	GS.scene_change.change(GS.LevelSelect)
	
	var root = get_node_or_null("/root/Root/")
	if root != null:
		GS.level_won_map[root.level_index] = true
