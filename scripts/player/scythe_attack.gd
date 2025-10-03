extends Area2D

var cooldown = false
var hit = false
var global_body

func _ready():
	body_entered.connect(_attack)
	$Timer.timeout.connect(_hide_weapon)

func _process(delta):
	if Input.is_action_just_pressed("stab") and cooldown == false:
		visible = true
		monitorable = true
		monitoring = true
		$Timer.start(0.3)
		$AnimatedSprite2D.play("swing")
		cooldown = true
		
func _attack(body):
	if body.process_priority == 1 and hit == false:
		body.health -= 40
		hit = true
		global_body = body
		

func _hide_weapon():
	visible = false
	monitorable = false
	monitoring = false
	cooldown = false
	hit = false
	$AnimatedSprite2D.stop()
	
