extends RigidBody2D

var direction = 1
var last_turn = 0
@export var wandering_dist = 50
@export var speed = 20

func _ready():
	last_turn = Time.get_ticks_msec()
	
func _physics_process(delta):
	position.x += direction * speed * delta
	
	var current_time = Time.get_ticks_msec()
	if current_time - last_turn > wandering_dist:
		last_turn = current_time
		direction *= -1
	
	

func _despawn():
	queue_free()
