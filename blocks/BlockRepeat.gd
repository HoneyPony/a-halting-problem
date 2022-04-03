extends "res://blocks/Block.gd"

export var repeats = 3

func _ready():
	$BlockList.repeats_left = repeats
	$BlockList.max_repeats_left = repeats
	
func _process(delta):
	$Sprite/Label2.text = String($BlockList.repeats_left)
