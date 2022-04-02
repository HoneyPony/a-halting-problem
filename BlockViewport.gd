extends ViewportContainer

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
