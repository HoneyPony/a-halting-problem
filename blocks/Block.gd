extends Node2D

var is_dragging = false
var drag_pos_start = Vector2.ZERO
var drag_mouse_start = Vector2.ZERO

var last_parent = null
var last_index = 0

var block_parent = null

onready var list_finder = $ListFinder

var is_a_drag_child = false
var drag_child_list = []

export var options = []

export var selected_option = 0

export var command = "stop"


var shine_t = 100.0

var options_enum = null

func get_option():
	var button = get_node_or_null("Sprite/Options")
	if button == null:
		return null
	return button.selected

func _ready():
	block_parent = get_parent()
	if block_parent.is_in_group("Block"):
		block_parent = block_parent.get_node("BlockList")
	
	var col1 = $CollisionShape2D
	var col2 = $ListFinder/CollisionShape2D
	
	# First 0.5: half the width.
	# Second 0.5: sprites are all 2x.
	var halfwidth = $Sprite.get_rect().size.x * 0.5 * 0.5
	
	col1.shape.extents.x = halfwidth
	col2.shape.extents.x = halfwidth
	col1.position.x = halfwidth
	col2.position.x = halfwidth
	
	if not options.empty():
		options_enum = get_node("Sprite/Options")
		for option in options:
			options_enum.add_item(option)
			
		options_enum.select(selected_option)

func get_height():
	# TODO: Make this more robust (also should it be more efficient?)!
	var bl = get_node_or_null("BlockList")
	if bl != null:
		var height = 128
		for b in bl.block_list:
			height += b.get_height()
		return height
		
	return 64

func _physics_process(delta):
	if options_enum != null:
		if options_enum == GS.current_held_block:
			if not options_enum.get_popup().visible:
				GS.current_held_block = null
				SFX.block_etc.play_sfx()
#	if reset_held_block_timer > 0.0:
#		reset_held_block_timer -= delta
#		if reset_held_block_timer <= 0:
#			GS.current_held_block = null
	
	if shine_t < 1.5:
		#print("shine t: ", shine_t)
		shine_t += (delta / GS.CODE_TIME_MAX)
		
		$Sprite.material.set_shader_param("shine_t", shine_t)
	
	if is_dragging:
		var diff = get_global_mouse_position() - drag_mouse_start
		global_position = drag_pos_start + diff
		
		if not Input.is_mouse_button_pressed(BUTTON_LEFT):
			end_drag()
			
	

func get_closest_list():
	var options_src = list_finder.get_overlapping_areas()
	
	var options = []
	for option in options_src:
		if not option.is_a_drag_child:
			options.append(option)
	
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

func clear_drag_children():
	for child in drag_child_list:
		child.is_a_drag_child = false
		
	drag_child_list.clear()

func end_drag():
	if GS.current_held_block != self:
		return
		
	GS.current_held_block = null
	
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
	clear_drag_children()
	
	# eh, the put one is too weird
	SFX.block_pick.play_sfx()
	
func mark_drag_children(list):
	var bl = get_node_or_null("BlockList")
	if bl != null:
		bl.is_a_drag_child = true
		list.append(bl)
		
		for child in bl.block_list:
			child.is_a_drag_child = true
			list.append(child)
			
			child.mark_drag_children(list)
			
	
func start_drag():
	if GS.current_held_block != null:
		return
	
	if is_dragging:
		return
		
	SFX.block_pick.play_sfx()
		
	GS.current_held_block = self
	
	z_index = 100
	
	last_parent = block_parent
	last_index = block_parent.block_list.find(self)
	
	#last_parent.remove_child(self)
	last_parent.block_list.erase(self)
	
	is_dragging = true
	drag_pos_start = global_position
	drag_mouse_start = get_global_mouse_position()
	
	drag_child_list.clear()
	mark_drag_children(drag_child_list)
	
func _on_Block_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == BUTTON_LEFT:
			start_drag()


func _on_Options_pressed():
	if GS.current_held_block == null:
		SFX.block_etc.play_sfx()
		GS.current_held_block = get_node("Sprite/Options")
	else:
		options_enum.get_popup().hide()

var reset_held_block_timer = -1.0

func _on_Options_button_up():
	pass
		#GS.current_held_block = null


func _on_Options_item_selected(index):
#	var opt = get_node("Sprite/Options")
#	if opt == GS.current_held_block:
#		#print("Reset", GS.current_held_block)
#		reset_held_block_timer = 0.1
	pass # Replace with function body.
