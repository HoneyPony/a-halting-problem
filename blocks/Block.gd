extends Node2D

var is_dragging = false
var drag_pos_start = Vector2.ZERO
var drag_mouse_start = Vector2.ZERO

var last_parent = null
var last_index = 0

var block_parent = null

onready var list_finder = $ListFinder

func _ready():
	block_parent = get_parent()

func get_height():
	# TODO: Make this more robust!
	var bl = get_node_or_null("BlockList")
	if bl != null:
		return bl.block_list.size() * 64 + 128
		
	return 64

func _process(delta):
	if is_dragging:
		var diff = get_global_mouse_position() - drag_mouse_start
		global_position = drag_pos_start + diff
		
		if not Input.is_mouse_button_pressed(BUTTON_LEFT):
			end_drag()

func get_closest_list():
	var options = list_finder.get_overlapping_areas()
	
	if options.empty():
		return null
		
	var closest = options[0]
	var x = closest.global_position.x
	
	for option in options:
		var ox = option.global_position.x
		if ox > x:
			closest = option
			x = ox
			
	return closest
	#print(options)

func end_drag():
	z_index = 0
	
	is_dragging = false
	
	var new_parent: Node2D = null
	var new_index = 0
	
	var closest_list = get_closest_list()
	
	if closest_list == null:
		new_parent = last_parent
		new_index = last_index
	else:
		new_parent = closest_list
		new_index = closest_list.compute_drop_index(self)
		
	#new_parent.add_child(self)
	new_parent.block_list.insert(new_index, self)
	
	block_parent = new_parent
	
func start_drag():
	z_index = 100
	
	last_parent = block_parent
	last_index = block_parent.block_list.find(self)
	
	#last_parent.remove_child(self)
	last_parent.block_list.erase(self)
	
	is_dragging = true
	drag_pos_start = global_position
	drag_mouse_start = get_global_mouse_position()
	
func _on_Block_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == BUTTON_LEFT:
			start_drag()
