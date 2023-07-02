extends Node2D


var playerS = preload("res://hero.tscn")
var lightTexture = preload("res://assets/Light.png")
var hud = preload("res://hud.tscn")

var cam = null

var lastLightningRand = 0
var lightningCD = 8
var lastLightning = lightningCD

@onready var sg = get_node("/root/MainSg")



# Called when the node enters the scene tree for the first time.
func _ready():
	startMatch()
	

func addPlayer():
	var player = playerS.instantiate()
	sg.player = player
	player.position = Vector2(240, 200)
	add_child(player)
	return player


func addCam(player):
	var cam = Camera2D.new()
	player.add_child(cam)
	cam.global_position = player.global_position
	cam.zoom = Vector2(0.35, 0.35)
	cam.limit_left = -510
	cam.limit_top = -510
	cam.limit_bottom = 30550
	cam.limit_right = 30530
	return cam
	

func addPl(player):
	var pl = PointLight2D.new()
	player.add_child(pl)
	pl.global_position = player.global_position
	pl.texture = lightTexture
	pl.scale = Vector2(3.5, 3.5)
	pl.shadow_enabled = true
	return pl


func startMatch():
	var player = addPlayer()
	var cam = addCam(player)
	var pl = addPl(player)
	

func setHud():
	if not sg.player:
		sg.healthBar.value = 0
		return
	if sg.healthBar.value == sg.healthBar.max_value:
		sg.healthBar
	sg.healthBar.max_value = sg.player.maxHealth
	sg.healthBar.value = sg.player.health
	sg.staminaBar.max_value = sg.player.sprintMax
	sg.staminaBar.value = sg.player.sprintMana




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not $crickets.playing:
		$crickets.play()
	lastLightning -= delta
	if lastLightning <= 0:
		lastLightningRand = RandomNumberGenerator.new().randi_range(0, 5)
		lastLightning = lightningCD + lastLightningRand
		var dl = DirectionalLight2D.new()
		add_child(dl)
		$lightning.play()
	elif lastLightning <= lightningCD + lastLightningRand - 1:
		for child in get_children():
			if "DirectionalLight2D" in child.name:
				child.queue_free()
	setHud()
	if not sg.player:
		$HUD.visible = false
	else:
		$HUD.visible = true
