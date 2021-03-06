extends ViewportContainer

onready var run_button = get_node("../ColorRect/RunButton")
onready var locked = get_node("../ColorRect/Locked")

func move_list():
	var list = get_node_or_null("../RootBlockList")
	if list != null:
		list.get_parent().remove_child(list)
		$Viewport/ListRoot.add_child(list)
		
		#list.position = Vector2(0, 0)
		#list.scale = Vector2(1, 1)

func _ready():
	locked.hide()
	
	call_deferred("move_list")

func _input( event ):
	if GS.code_execute_flag:
		return
	
	if event is InputEventMouse:
		var mouseEvent = event.duplicate()
		mouseEvent.position = get_global_transform().xform_inv(event.global_position)
		$Viewport.unhandled_input(mouseEvent)
	else:
		$Viewport.unhandled_input(event)


func _on_Button_pressed():
	if not GS.code_execute_flag:
		GS.code_execute_flag = true
		
func _physics_process(delta):
	var run_button_alpha = 1.0
	if GS.code_execute_flag:
		run_button_alpha = 0.0
		
	run_button.modulate.a += (run_button_alpha - run_button.modulate.a) * 0.2
	locked.modulate.a = 1.0 - run_button.modulate.a
	
	run_button.visible = run_button.modulate.a > 0.01
	locked.visible = locked.modulate.a > 0.01
		
	
