extends Spatial

onready var mesh = $Mesh

onready var mouse_check = $MouseDetect

onready var bubble = $Bubble

var bubble_alpha_t = 0.0

var pickup_anim_t = -1.0
var PICKUP_ANIM_MAX = 0.8
var pickup_anim_start: Vector3

func update_alpha(a):
	bubble.get_active_material(0).albedo_color.a = a
	
func get_alpha():
	return bubble.get_active_material(0).albedo_color.a 

func _ready():
	update_alpha(0.0)
	
	if list_scene != null:
		var x = list_scene.instance()
		get_node("Viewport").call_deferred("add_child", x)
	pass
	
	#bubble.scale = Vector3.ZERO

export var list_scene: PackedScene = null

func check_player():
	
	var bodies = $DetectBot.get_overlapping_bodies()
	if not bodies.empty():
		var root = get_tree().get_nodes_in_group("CodeRoot")[0]
		
		if list_scene == null:
			return
		
		#var my_list = get_node("Viewport/Root/BlockList")
		var my_list = list_scene.instance().get_node("BlockList")
		
		for item in my_list.get_children():
			#var x = BM.instance()
			#root.block_list.append(x)
			#x.block_parent = root
			
			#root.add_child(x)
			
			if item.is_in_group("Block"):
			
				root.block_list.append(item)
				item.block_parent = root
				
				item.get_parent().remove_child(item)
				root.add_child(item)
			
			item.position = Vector2(0, 2000)
			
		my_list.block_list = []
		
		GS.code_stop_next_flag = true
		
		pickup_anim_t = PICKUP_ANIM_MAX
		pickup_anim_start = global_transform.origin

var mouse_frames = 0

func update_mouse():
	var camera = GS.cam_3d
	var from = camera.project_ray_origin(get_viewport().get_mouse_position())
	var to = from + camera.project_ray_normal(get_viewport().get_mouse_position()) * 400
	
	var sstate = get_world().direct_space_state
	var result = sstate.intersect_ray(from, to, [], $MouseDetect.collision_layer)
	
	if result:
		has_mouse = (result.collider == $MouseDetect)
	else:
		has_mouse = false
	

func _physics_process(delta):
	update_mouse()
	
	mesh.rotate_y(3 * delta)
	

	
	if pickup_anim_t >= 0.0:
		pickup_anim_t -= delta
		
		bubble.hide()
		var t = 1.0 - (pickup_anim_t / PICKUP_ANIM_MAX)
		global_transform.origin = pickup_anim_start.linear_interpolate(GS.bot.global_transform.origin, t)
		
		scale = Vector3(1.0 - t, 1.0 - t, 1.0 - t)
		
		if pickup_anim_t <= 0.0:
			queue_free()
			
		return
	
	if has_mouse:
		mouse_frames += 1
	else:
		mouse_frames -= 1
		
	mouse_frames = clamp(mouse_frames, 0, 10)
	bubble_alpha_t = 0.0
	if mouse_frames >= 5:
		bubble_alpha_t = 1.0
	
	var a = get_alpha()
	var a2 = bubble_alpha_t
	if GS.cam_3d_dragging:
		a2 = 0.0
	a += (a2 - a) * 0.2
	update_alpha(a)
	bubble.visible = a > 0.01
	
	check_player()
	
	#bubble.scale += (bubble_scale_target - bubble.scale) * 0.08
	#bubble.visible = bubble.scale.x > 0.01

	#bubble.look_at(GS.cam_3d.global_transform.origin, Vector3.UP)

var has_mouse = false

func _on_MouseDetect_mouse_entered():
	pass
	#print("MOUSE")
	##has_mouse = true
	#ubble_alpha_t = 1.0
	#bubble.show()


func _on_MouseDetect_mouse_exited():
	pass
	#has_mouse = false
	#bubble_alpha_t = 0.0
	#bubble.hide()
