extends Node

var Game = preload("res://levels/Level1.tscn")

var code_execute_flag = false

var code_stop_next_flag = false

func reset():
	code_execute_flag = false
	code_stop_next_flag = false
	current_held_block = null

var current_held_block = null

var cam_3d = null
var cam_3d_dragging = false

var bot = null

var CODE_TIME_MAX = 0.5

var scene_change = null
