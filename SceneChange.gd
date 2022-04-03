extends CanvasLayer

func _ready():
	get_tree().paused = false
	
	GS.reset()
	GS.scene_change = self
	
var change_to = null
	
func change(scene: PackedScene, same_scene_flag = false):
	change_to = scene
	$AnimationPlayer.play("FadeOut")
	
	GS.is_same_scene_flag = same_scene_flag

func faded_out():
	get_tree().change_scene_to(change_to)
