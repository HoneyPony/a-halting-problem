extends "res://blocks/Block.gd"

func _ready():
	$BlockList.repeats_left = 3
	
func _process(delta):
	$Sprite/Label2.text = String($BlockList.repeats_left)
