extends Button

export var parent_path: NodePath

func on_pressed():
	get_node(parent_path).queue_free()

func _ready():
	connect("pressed", self, "on_pressed")
	
	if GS.is_same_scene_flag:
		get_node(parent_path).queue_free()
