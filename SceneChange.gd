extends CanvasLayer

func _ready():
	GS.reset()
	GS.scene_change = self
	
var change_to = null
	
func change(scene: PackedScene):
	change_to = scene
	$AnimationPlayer.play("FadeOut")

func faded_out():
	get_tree().change_scene_to(change_to)
