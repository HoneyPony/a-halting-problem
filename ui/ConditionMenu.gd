extends ColorRect

enum Cond {
	Win,
	Stopped,
	Fell
}

export(Cond) var cond = Cond.Win

func _ready():
	hide()
	modulate.a = 0

func condition():
	if cond == Cond.Win:
		return GS.bot_has_won
	
	if cond == Cond.Stopped:
		return GS.bot_is_stopped and not GS.bot_has_won
	
	if cond == Cond.Fell:
		return GS.bot.global_transform.origin.y < -8
	
	return false
	
func _physics_process(delta):
	var target_alpha = 0.0
	if condition():
		target_alpha = 1.0
		
	modulate.a += (target_alpha - modulate.a) * 0.2
	visible = modulate.a > 0.01
