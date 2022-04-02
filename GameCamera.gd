extends Camera

var drag_start_mouse
var drag_start_tform

onready var block_viewport = get_node("../../BlockLayer/BlockViewport")

func _ready():
	GS.cam_3d = self


func begin_drag():
	drag_start_mouse = get_viewport().get_mouse_position()
	if drag_start_mouse.x >= block_viewport.get_global_rect().position.x:
		return
	
	GS.cam_3d_dragging = true
	
	drag_start_tform = get_parent().transform.origin
			
func _physics_process(delta):
	if not Input.is_mouse_button_pressed(BUTTON_LEFT):
		GS.cam_3d_dragging = false
	elif not GS.cam_3d_dragging:
		begin_drag()
		
	if GS.cam_3d_dragging:
		var mouse_dif = get_viewport().get_mouse_position() - drag_start_mouse
		
		mouse_dif /= get_viewport().get_size()
		
		var dif = Vector3(-mouse_dif.x, 0, -mouse_dif.y) * 10
		
		get_parent().transform.origin = drag_start_tform + dif
