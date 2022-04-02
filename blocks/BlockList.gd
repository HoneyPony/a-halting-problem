extends Node2D

var block_list = []

onready var col = $CollisionShape2D
onready var col_shape: RectangleShape2D = $CollisionShape2D.shape

func _ready():
	for child in get_children():
		if child.is_in_group("Block"):
			block_list.append(child)

func compute_drop_index(node):
	var index = 0
	
	for block in block_list:
		if block.global_position.y < node.global_position.y:
			index += 1
			
		block.block_parent = self
			
	return index

func arrange_children():
	var x = 0
	var y = 0
	
	for child in block_list:
		
		var target_x = global_position.x + x
		var target_y = global_position.y + y + 32
		
		var target = Vector2(target_x, target_y)
		
		child.global_position += (target - child.global_position) * 0.3
		
		y += child.get_height()
		
	y += 32
		
	col_shape.extents.y = y * 0.5
	col.position.y = col_shape.extents.y
		
func _process(delta):
	arrange_children()
