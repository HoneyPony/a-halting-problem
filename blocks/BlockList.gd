extends Node2D

var block_list = []
var is_a_drag_child = false

onready var col = $CollisionShape2D
onready var col_shape: RectangleShape2D = $CollisionShape2D.shape

onready var empty_block = $EmptyBlock

var delegate = null
var run_index = 0
var max_repeats_left = 3
var repeats_left = 0
export var run_by_deleting = false

func reset_for_run():
	delegate = null

func get_next_command():
	if get_parent().is_in_group("Block"):
		get_parent().shine_t = 0
	
	if delegate != null:
		return delegate.get_next_command()
		
	if block_list.empty():
		return null
		
	# In case the list size changes between runs.
	if run_index >= block_list.size():
		run_index = 0
	var command = block_list[run_index]
	
	if command.command == "repeat":
		delegate = command.get_node("BlockList")
		#if not run_by_deleting:
		#	run_index = (run_index + 1) % block_list.size()
		return delegate.get_next_command()
	
	return command
	
func erase_all_children():
	for block in block_list:
		#print("erasing block: ", block)
		
		var bl = block.get_node_or_null("BlockList")
		if bl != null:
			bl.erase_all_children()
			
		block.queue_free()
	block_list = []
	
	#print("my block list: ", block_list)
	
func finished(command):
	if delegate != null:
		var new_delegate = delegate.finished(command)
		
		if run_by_deleting:
			#print("new delegate: ", new_delegate)
			
			if new_delegate == null:
				#print("Got to delete delegate...")
				
				var parent = delegate.get_parent()
				
				delegate.erase_all_children()
				
				# Erase the repeat block itself.
				block_list.erase(parent)
				parent.queue_free()
				
			delegate = new_delegate
				
			return
		
		delegate = new_delegate
		
		if delegate != null:
			return self
		
	
	if command == null:
		return null
	
	if run_by_deleting:
		block_list.erase(command)
		command.queue_free()
		
	else:
		run_index += 1
		if run_index >= block_list.size():
			run_index = 0
			
			repeats_left -= 1
			
			if repeats_left <= 0:
				repeats_left = max_repeats_left
				return null
					
		return self
			
	return null

# This moves the *node objects themselves*, as if a node
# is *originally parented* to a block list, but then the list
# is deleted, the node will be deleted too, even though it isn't
# parented in the meta-tree anymore.
func move_child_nodes_to_root():
	var desired_root = self
	while desired_root != null:
		if desired_root.is_in_group("CodeRoot"):
			break
		desired_root = desired_root.get_parent()
		
	if desired_root == self:
		return
		
	for child in get_parent().get_children():
		if child.is_in_group("Block"):
			get_parent().remove_child(child)
			desired_root.add_child(child)

func _ready():
	for child in get_children():
		if child.is_in_group("Block"):
			block_list.append(child)
			
	if get_parent().is_in_group("Block"):
		for child in get_parent().get_children():
			if child.is_in_group("Block"):
				block_list.append(child)
	else:
		arrange_children(true)
		
	call_deferred("move_child_nodes_to_root")

func compute_drop_index(node):
	var index = 0
	
	for block in block_list:
		if block.global_position.y < node.global_position.y:
			index += 1
			
		#block.block_parent = self
			
	return index

func arrange_children(force = false):
	var x = 0
	var y = 0
	
	for child in block_list:
		
		var local = child.global_position - global_position
		
		var target_x = x
		var target_y = y + 32 * global_scale.y
		
		var target = Vector2(target_x, target_y)
		
		var f = 0.3
		if child.is_a_drag_child:
			f = 1.0
			
		if force:
			f = 1.0
			
		local += (target - local) * f
		child.global_position = global_position + local
		#child.global_position += (target - child.global_position) * f
		
		y += child.get_height() * global_scale.y
		
		if force:
			var bl = child.get_node_or_null("BlockList")
			if bl != null:
				bl.arrange_children(true)
		
	$EmptyBlock.global_position.y = global_position.y + y #+ 32 * global_scale.y
		
	y += 32 * global_scale.y
		
	my_height = y
		
	col_shape.extents.y = y * 0.5 / global_scale.y
	col.position.y = col_shape.extents.y
		
var my_height
		
func _process(delta):
	arrange_children()
