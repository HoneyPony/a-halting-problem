extends Button

export var index = 0

func _ready():
	var check = get_node_or_null("Check")
	if check:
		var tex = GS.TexUnchecked
		if GS.level_won_map.get(index, false):
			tex = GS.TexChecked
			
		check.texture = tex

func _on_pressed():
	var scene = GS.levels[index]
	GS.current_level = scene
	
	GS.scene_change.change(GS.current_level)
