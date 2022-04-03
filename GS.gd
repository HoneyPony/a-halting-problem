extends Node

var TexChecked = preload("res://ui/check_checked.svg")
var TexUnchecked = preload("res://ui/check_empty.svg")

var LevelSelect = preload("res://LevelSelect.tscn")

var levels = [
	preload("res://levels/Introduction.tscn"),
	
	preload("res://levels/Level1.tscn"),
	
	preload("res://levels/LevelSnakePath.tscn"), 
	preload("res://levels/LevelGrabBox.tscn"),
	
	preload("res://levels/LevelChoiceOfBoxes.tscn"),
	preload("res://levels/LevelScenicRoute.tscn"),  # index 5
	
	preload("res://levels/LevelFirstRep.tscn"),
	
	preload("res://levels/LevelStairStep.tscn"), # index 7
	preload("res://levels/LevelLongShot.tscn"), # index 8
	preload("res://levels/LevelTwistyCurve.tscn"),
]

func beat_all(start, end):
	for i in range(start, end + 1):
		var won = level_won_map.get(i, false)
		if not won:
			return false
	return true

func compute_group_enables():
	group_enables[0] = true
	group_enables[1] = beat_all(0, 0)
	group_enables[2] = beat_all(0, 1)
	group_enables[3] = beat_all(0, 3)
	group_enables[4] = beat_all(0, 5)
	group_enables[5] = beat_all(0, 6)
	
	print(group_enables)
	print(level_won_map)

var group_enables =[
	true,
	false,
	false,
	false,
	false,
	false
]

var group_alpha = [
	1.0,
	0.0,
	0.0,
	0.0,
	0.0,
	0.0
]

var current_level: PackedScene = null

var level_won_map = {}

var code_execute_flag = false

var code_stop_next_flag = false

var is_same_scene_flag = false

func reset():
	code_execute_flag = false
	code_stop_next_flag = false
	current_held_block = null
	bot_is_stopped = false
	bot_has_won = false
	cam_3d_dragging = false

var current_held_block = null

var cam_3d = null
var cam_3d_dragging = false

var bot = null

var CODE_TIME_MAX = 0.5

var scene_change = null

var bot_is_stopped = false
var bot_has_won = false
