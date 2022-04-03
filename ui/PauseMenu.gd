extends Control

var menu_open = false

onready var menu = $Menu

onready var pause_button = $PauseButton

func _ready():
	menu.modulate.a = 0
	menu.hide()

func toggle_menu():
	menu_open = !menu_open
	
	get_tree().paused = menu_open
	
	#print("TOGGLE MENU")
	
func _physics_process(delta):
	var target_alpha = 0.0
	if menu_open:
		target_alpha = 1.0

	menu.modulate.a += (target_alpha - menu.modulate.a) * 0.2
	menu.visible = menu.modulate.a > 0.01
	
	pause_button.modulate.a = 1.0 - menu.modulate.a
	pause_button.visible = pause_button.modulate.a > 0.01
	
	#var filter = MOUSE_FILTER_IGNORE
	#if menu.visible:
	#	filter = MOUSE_FILTER_STOP
	#menu.mouse_filter = filter
