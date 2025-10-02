extends Area2D

func _ready():
	body_entered.connect(_body_entered)
	body_exited.connect(_body_exited)
	
func _body_entered(body):
	if body.name == "Player":
		body.cooldown = true
		body.no_wallclimb = true
		print("entered")
		
func _body_exited(body):
	if body.name == "Player":
		body.cooldown = false
		body.no_wallclimb = false
		print("exited")
