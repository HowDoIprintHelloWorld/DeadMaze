extends Node2D


@export var speed = 2000

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	position += delta * global_transform.basis_xform(Vector2.UP) * speed
	



func _on_area_2d_body_entered(body):
	if "enemy" in body.get_groups():
		body.damage(5)
	queue_free()
