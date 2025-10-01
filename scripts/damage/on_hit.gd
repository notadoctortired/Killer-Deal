extends Area2D

var body_global = null

func _ready():
	body_entered.connect(_body_entered)
	body_exited.connect(_body_left)
	$Timer.timeout.connect(_timeout)
	
func _body_entered(body):
	if body.name == "Player":
		body.health -= 10
		$Timer.start(0.5)
		body_global = body
	
func _body_left(body):
	if body.name == "Player":
		$Timer.stop()
		
func _timeout():
	body_global.health -= 10
	$Timer.start(0.5)
