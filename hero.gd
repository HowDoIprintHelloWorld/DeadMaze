extends CharacterBody2D


const SPEED = 600.0
const JUMP_VELOCITY = -400.0

var sprintMax = 2
var sprintMana = sprintMax
var sprintRanOut = false

var maxHealth = 10
var health = maxHealth

var shootMax = 0.2
var shootCD = shootMax

@onready var gun = $gun
@onready var bulletScene = preload("res://bullet.tscn")
@onready var bulletPos = $gun/bulletPos

@onready var aimFrame = preload("res://assets/frame_00011.png")
@onready var runFrame = preload("res://assets/frame_00010.png")


func attack(dmg):
	health -= dmg
	if health <= 0:
		queue_free()


func addSprint(delta):
	if sprintMana < sprintMax:
		sprintMana += delta
		if sprintMana > sprintMax:
			sprintMana = sprintMax


func increaseSprintMana(delta):
	if sprintMana <= 0:
		sprintRanOut = true
		addSprint(delta)
		return false

func sprint(delta):
	increaseSprintMana(delta)
	if Input.is_action_pressed("shift"):
		if sprintRanOut:
			if sprintMana > sprintMax*0.3:
				sprintRanOut = false
			else:
				addSprint(delta)
				return false
		if sprintMana > 0:
			sprintMana -= delta
			return true
	addSprint(delta)
	
			

func shootAndMove(delta):
	look_at(get_global_mouse_position())
	rotate(deg_to_rad(90))
	shootCD += delta
	if shootCD > shootMax:
		shootCD = shootMax
	if Input.is_action_pressed("rightClick"):
		$Sprite2D.texture = aimFrame
		gun.rotation = deg_to_rad(0)
		if Input.is_action_pressed("click") and shootCD == shootMax and sprintMana > 0:
			sprintMana -= 0.3
			shootCD = 0
			var bullet = bulletScene.instantiate()
			bullet.position = bulletPos.global_position
			bullet.rotation =  rotation
			get_tree().root.add_child(bullet)
			return 1
		return 1
	$Sprite2D.texture = runFrame
	gun.rotation = deg_to_rad(-81.6)
	if sprint(delta):
		return 2.2
	return 1.4


func heal(delta):
	if health < maxHealth:
		health += 0.3 * delta
		if health > maxHealth:
			health = maxHealth


func _physics_process(delta):
	heal(delta)
	var input_direction = Input.get_vector("left", "right", "up", "down")

	var speedMultiplier = shootAndMove(delta)
	velocity = input_direction.normalized() * SPEED * speedMultiplier
	if velocity == Vector2(0, 0) and speedMultiplier >= 1.4:
		addSprint(delta)
	move_and_slide()
