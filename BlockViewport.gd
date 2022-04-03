extends ViewportContainer

func move_list():
	var list = get_node_or_null("../RootBlockList")
	if list != null:
		list.get_parent().remove_child(list)
		$Viewport/ListRoot.add_child(list)
		
		#list.position = Vector2(0, 0)
		#list.scale = Vector2(1, 1)

func _ready():
	call_deferred("move_list")

func _input( event ):
	if event is InputEventMouse:
		var mouseEvent = event.duplicate()
		mouseEvent.position = get_global_transform().xform_inv(event.global_position)
		$Viewport.unhandled_input(mouseEvent)
	else:
		$Viewport.unhandled_input(event)


func _on_Button_pressed():
	if not GS.code_execute_flag:
		GS.code_execute_flag = true
