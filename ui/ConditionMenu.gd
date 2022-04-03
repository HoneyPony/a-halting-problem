extends ColorRect

enum Cond {
	Win,
	Stopped,
	Fell
}

export(Cond) var cond = Cond.Win

var last_condition

func _ready():
	hide()
	modulate.a = 0
	
	last_condition = false

func condition():
	if cond == Cond.Win:
		return GS.bot_has_won
	
	if cond == Cond.Stopped:
		return GS.bot_is_stopped and not GS.bot_has_won
	
	if cond == Cond.Fell:
		return GS.bot.global_transform.origin.y < -8
	
	return false
	
func sfx():
	if cond == Cond.Win:
		SFX.victory.play_usual()
	else:
		SFX.defeat.play_usual()
	
func _physics_process(delta):
	var target_alpha = 0.0
	
	var c = condition()
	if c:
		target_alpha = 1.0
		
	modulate.a += (target_alpha - modulate.a) * 0.2
	visible = modulate.a > 0.01
	
	if c != last_condition:
		sfx()
		
	last_condition = c
