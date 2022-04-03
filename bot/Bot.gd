extends KinematicBody

var code_timer = 0.3


func finish_current_line():
	if current_command != null:
		if current_command.command == "stop":
			GS.bot_is_stopped = true
			if on_goal:
				GS.bot_has_won = true
	
	src_list.finished(current_command)
	current_command = null
	
	var current_pos = global_transform.origin
	current_pos.x = round(current_pos.x / 2) * 2
	current_pos.z = round(current_pos.z / 2) * 2
	#current_pos.y = 0
	
	var current_rot = rotation_degrees
	current_rot.y = round(current_rot.y / 90) * 90
	rotation_degrees = current_rot
	
	rot_start = Quat(rotation)
	rot_end = rot_start
	
	global_transform.origin.x = current_pos.x
	global_transform.origin.z = current_pos.z
	move_start = current_pos
	move_end = current_pos

func execute_next_line():	

	
	code_timer = GS.CODE_TIME_MAX
	
	current_command = src_list.get_next_command()
	
	
	#print("Current command: ", current_command)
	
	if current_command == null:
		return
		
	current_command.shine_t = 0.0
	
	#print("    (text: ",current_command.command, ")")
	
	if current_command.command == "move":
		move_command(current_command)
	if current_command.command == "rotate":
		rotate_command(current_command)
	#if current_command.command == "stop":
	#	GS.bot_is_stopped = true
	
	
var move_start: Vector3
var move_end: Vector3

var rot_start: Quat
var rot_end: Quat

var current_command = null

var src_list

func _ready():
	GS.bot = self
	
	move_end = global_transform.origin
	move_start = move_end
	
	rot_start = Quat(rotation)
	rot_end = rot_start
	
	src_list = get_tree().get_nodes_in_group("CodeRoot")[0]

func move_command(command):
	var offset = Vector3.ZERO
	
	var option = command.get_option()
	if option == 0:
		offset += transform.basis.z
	if option == 1:
		offset -= transform.basis.z
	#if option == 2:
	#	offset.x -= 1
	#if option == 3:
	#	offset.x += 1
		
	offset *= 2.0
	
	move_start = global_transform.origin
	move_end = move_start + offset
	
func rotate_command(command):
	var rot = rotation
	
	var delta_y = PI / 2.0
	if command.get_option() == 1:
		delta_y *= -1
	
	rot.y += delta_y
	rot_end = Quat(rot)
	rot_start = Quat(rotation)

var grav_vel = Vector3.ZERO

var on_goal = false

func check_win():
	on_goal = false
	
	for goal in get_tree().get_nodes_in_group("Goal"):
		var pos = goal.global_transform.origin + Vector3(0.0, 1.0, 0.0)
		var dist = global_transform.origin.distance_squared_to(pos)
		
		#print(dist)
		
		if dist <= 0.2 * 0.2:
			on_goal = true

func _physics_process(delta):
	if GS.bot_is_stopped:
		return
		
	# Stop processing once we fall off.
	if global_transform.origin.y < -8:
		hide()
		return
	
	if GS.code_execute_flag:
		code_timer -= delta
		if code_timer <= 0:
			finish_current_line()
			
			# The arrangement of the stopping code is so that
			# the animation is still played. Need a guard before
			# so we don't execute more code, and one after so
			# that after we call finish() we don't do anything.
			if GS.bot_is_stopped:
				return
			
			if GS.code_stop_next_flag:
				GS.code_execute_flag = false
				GS.code_stop_next_flag = false
				
				src_list.reset_for_run()
			else:
				if global_transform.origin.y >= -0.01:
					# Only execute if we're still on.
					execute_next_line()
				
	else:
		code_timer = GS.CODE_TIME_MAX
		

		
	var move_t = 1.0 - (code_timer / GS.CODE_TIME_MAX)
	
	var goal_position = move_start.linear_interpolate(move_end, move_t)
	var amount_to_move = goal_position - global_transform.origin
	
	amount_to_move.y = 0
	
	var rot_quat = rot_start.slerp(rot_end, move_t)
	rotation = rot_quat.get_euler()
	
	# Only allow us to move on solid ground.
	if global_transform.origin.y >= -0.3:
		move_and_collide(amount_to_move)
	
	grav_vel = move_and_slide(grav_vel + Vector3.DOWN * 30 * delta)

	check_win()
