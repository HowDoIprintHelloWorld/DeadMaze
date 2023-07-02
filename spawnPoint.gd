extends Node2D

var rng = RandomNumberGenerator.new()
var lastAttempt = 0

var zombieS = preload("res://zombert.tscn")

@export var spawnOdds = 10


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	lastAttempt += delta
	if lastAttempt >= 1:
		lastAttempt = 0
		if rng.randi_range(1, 100) < spawnOdds:
			var zombie = zombieS.instantiate()
			get_tree().root.add_child(zombie)
			zombie.position = position
