extends Button

export var parent_path: NodePath
var pause_layer

func on_pressed():
	if pause_layer:
		pause_layer.show()
	get_node(parent_path).queue_free()

func _ready():
	connect("pressed", self, "on_pressed")
	
	if GS.is_same_scene_flag:
		get_node(parent_path).queue_free()
	else:
		pause_layer = get_node(parent_path).get_node_or_null("../PauseLayer")
		
		if pause_layer:
			pause_layer.call_deferred("hide")
