extends RigidBody2D

var direction = 1
var last_turn = 0
@export var wandering_dist = 50
@export var speed = 20
var health = 100

func _ready():
	last_turn = Time.get_ticks_msec()
	
func _physics_process(delta):
	position.x += direction * speed * delta
	
	var current_time = Time.get_ticks_msec()
	if current_time - last_turn > wandering_dist:
		last_turn = current_time
		direction *= -1
	
	$EnemyUI/Health.value = health
	
	if health <= 0:
		get_parent().get_node("Player").kills += 1
		get_parent().get_node("Player").lives += 1
		
		var kills = get_parent().get_node("Player").kills
		var lives = get_parent().get_node("Player").lives
		
		get_parent().get_node("PhantomCamera2D/PlrUI/Lives").text = str(lives)
		get_parent().get_node("PhantomCamera2D/PlrUI/Kills").text = str(kills)
		
		
		queue_free()

func _despawn():
	queue_free()
