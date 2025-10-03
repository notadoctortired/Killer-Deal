extends Area2D

func _ready():
	body_entered.connect(_body_entered)
	
func _body_entered(body):
	if body.name == "Player" or body.process_priority == 1:
		body.health = 0
