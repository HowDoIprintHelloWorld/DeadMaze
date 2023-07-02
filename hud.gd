extends CanvasLayer


@onready var sg = get_node("/root/MainSg")


# Called when the node enters the scene tree for the first time.
func _ready():
	sg.healthBar = $healthBar
	sg.staminaBar = $staminaBar


func fixBorders(bar):
	var newTheme = bar.get_theme_stylebox("fill")
	if bar.value == bar.max_value:
		newTheme.border_width_right = 3
	else:
		newTheme.border_width_right = 0
	bar.add_theme_stylebox_override("fill", newTheme)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fixBorders($healthBar)
	fixBorders($staminaBar)
	
