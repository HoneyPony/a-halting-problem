extends Spatial

onready var mesh = $Mesh

onready var mouse_check = $MouseDetect

onready var bubble = $Bubble

var bubble_alpha_t = 0.0

func update_alpha(a):
	bubble.get_active_material(0).albedo_color.a = a
	
func get_alpha():
	return bubble.get_active_material(0).albedo_color.a 

func _ready():
	pass
	
	#bubble.scale = Vector3.ZERO

func _physics_process(delta):
	mesh.rotate_y(3 * delta)
	
	var a = get_alpha()
	a += (bubble_alpha_t - a) * 0.2
	update_alpha(a)
	bubble.visible = a > 0.01
	
	#bubble.scale += (bubble_scale_target - bubble.scale) * 0.08
	#bubble.visible = bubble.scale.x > 0.01

	#bubble.look_at(GS.cam_3d.global_transform.origin, Vector3.UP)

func _on_MouseDetect_mouse_entered():
	bubble_alpha_t = 1.0
	#bubble.show()


func _on_MouseDetect_mouse_exited():
	bubble_alpha_t = 0.0
	#bubble.hide()
