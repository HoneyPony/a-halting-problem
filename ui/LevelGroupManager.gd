extends Control

onready var groups = [
	$Group0,
	$Group1,
	$Group2,
	$Group3,
	$Group4,
	$Group5,
	$Group6
]

var wait_to_reveal = 0.8

func _ready():
	for i in range(0, groups.size()):
		var alpha = GS.group_alpha[i]
		
		groups[i].modulate.a = alpha
		groups[i].visible = alpha > 0.01
		
	GS.compute_group_enables()

func _physics_process(delta):
	if wait_to_reveal > 0:
		wait_to_reveal -= delta
		return
	
	
	for i in range(0, groups.size()):
		var alpha = GS.group_alpha[i]
		
		var target = 0.0
		if GS.group_enables[i]:
			target = 1.0
			
		var f = 0.05
		if alpha > 0.5:
			f = 0.1
		if alpha > 0.96:
			f = 1.0
		alpha += (target - alpha) * f
		
		GS.group_alpha[i] = alpha
		
		groups[i].modulate.a = alpha
		groups[i].visible = alpha > 0.01


