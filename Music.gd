extends Node

var drums_linear = 0.0

func _process(delta):
	var drums = false
	
	var root = get_node_or_null("/root/Root")
	if root != null:
		drums = !root.no_drums
		
	var drums_delta = -1.0
	if drums:
		drums_delta = 1.0
		
	drums_delta *= 2.0 # Half-second fade.?
	
	drums_linear = clamp(drums_linear + drums_delta * delta, 0.0, 1.0)
	$Drums.volume_db = linear2db(drums_linear)
