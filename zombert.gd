extends CharacterBody2D


const SPEED = 1000.0
const JUMP_VELOCITY = -400.0
var pos = null
var direction = Vector2(0, 0)

var health = 10

var lastAttack = 0
var attackCd = 0.4
var attacking = false

@onready var navagent = $NavigationAgent2D


func damage(dmg):
	health -= dmg
	if health <= 0:
		queue_free()


func attack(delta):
	$AnimationPlayer.play("attack")
	lastAttack += delta
	if lastAttack > attackCd:
		lastAttack = attackCd
	else:
		return
	attacking = true
	for body in $hitterBox.get_overlapping_bodies():
		if body.is_in_group("hero"):
			body.attack(4)
			lastAttack = 0
			return
	


func _physics_process(delta):
	if not (navagent.is_target_reached() or navagent.distance_to_target() < 100):
		attacking = false
		var nextPos = navagent.get_next_path_position()
		direction = (nextPos - global_position).normalized()
		look_at(nextPos)
		rotate(deg_to_rad(90))
	else:
		attack(delta)
		direction = Vector2(0, 0)
		return
	
	velocity = direction * SPEED
	$AnimationPlayer.queue("run")

	move_and_slide()


func _on_timer_timeout():
	$Sprite2D.light_mask
	var player = get_tree().get_nodes_in_group("hero")
	if player:
		navagent.target_position = player[0].position
	else:
		queue_free()
