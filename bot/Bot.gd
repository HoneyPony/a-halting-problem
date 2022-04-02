extends KinematicBody

var code_timer = 0.3
var CODE_MAX = 0.5

func finish_current_line():
	src_list.finished(current_command)
	current_command = null
	
	var current_pos = global_transform.origin
	current_pos.x = round(current_pos.x / 2) * 2
	current_pos.z = round(current_pos.z / 2) * 2
	current_pos.y = 0
	
	global_transform.origin = current_pos
	move_start = current_pos
	move_end = current_pos

func execute_next_line():	

	
	code_timer = CODE_MAX
	
	current_command = src_list.get_next_command()
	
	#print("Current command: ", current_command)
	
	if current_command == null:
		return
	
	#print("    (text: ",current_command.command, ")")
	
	if current_command.command == "move":
		move_command(current_command)
	
	
var move_start: Vector3
var move_end: Vector3

var current_command = null

var src_list

func _ready():
	GS.bot = self
	
	move_end = global_transform.origin
	
	src_list = get_tree().get_nodes_in_group("CodeRoot")[0]

func move_command(command):
	var offset = Vector3.ZERO
	
	var option = command.get_option()
	if option == 0:
		offset.z -= 1
	if option == 1:
		offset.z += 1
	if option == 2:
		offset.x -= 1
	if option == 3:
		offset.x += 1
		
	offset *= 2.0
	
	move_start = global_transform.origin
	move_end = move_start + offset

func _physics_process(delta):
	if GS.code_execute_flag:
		code_timer -= delta
		if code_timer <= 0:
			finish_current_line()
			
			if GS.code_stop_next_flag:
				GS.code_execute_flag = false
				GS.code_stop_next_flag = false
				
				src_list.reset_for_run()
			else:
				execute_next_line()
	else:
		code_timer = CODE_MAX
		
	var move_t = 1.0 - (code_timer / CODE_MAX)
	
	var goal_position = move_start.linear_interpolate(move_end, move_t)
	var amount_to_move = goal_position - global_transform.origin
	
	move_and_collide(amount_to_move)
