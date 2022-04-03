extends Node

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
