extends Button

func on_pressed():
	get_parent().queue_free()

func _ready():
	connect("pressed", self, "on_pressed")
