extends StaticBody

var theta = 0.0

var freq_f = 1.0

var actual_mag = 0.0

func _ready():
	freq_f = rand_range(0.3, 0.7)
	theta = rand_range(0.0, TAU)

func offset_sin(x):
	return 0.5 * (sin(x) - 1)

func _physics_process(delta):
	var dist_to_bot = global_transform.origin.distance_to(GS.bot.global_transform.origin)
	
	var mag = (dist_to_bot - 1.0) * (0.5 / 2.0)
	mag = clamp(mag, 0.0, 0.3)
	
	if mag < actual_mag:
		actual_mag = mag
	else:
		actual_mag += (mag - actual_mag) * 0.1
	
	theta += freq_f * delta
	if theta >= TAU:
		theta -= TAU
		
	$Viz.transform.origin.y = offset_sin(theta) * actual_mag
