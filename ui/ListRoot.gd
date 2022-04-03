extends Node2D

var scroll_amount = 8

func _input(event):
	if event is InputEventMouseButton:
		
		if event.is_pressed() and event.position.x >= 0:
			if event.button_index == BUTTON_WHEEL_UP:
				scroll_amount += 20
			if event.button_index == BUTTON_WHEEL_DOWN:
				scroll_amount -= 20

func _physics_process(delta):
	var max_scroll = -scroll_amount
	
	for child in get_children():
		if child.is_in_group("CodeRoot"):
			max_scroll = child.my_height


	scroll_amount = clamp(scroll_amount, -max_scroll, 8)
	
	position.y = scroll_amount
