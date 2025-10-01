extends CharacterBody2D

@export var speed = 300.0
@export var jump_vel = -400.0
@export var dash = 2000
@export var health = null

var first = true
var health_bar = null

var cooldown = false
var cooldown_timer = 0.5

var dashing = false
var dashing_timer = 0.1
var dashing_cooldown = false
var dashing_cooldown_timer = 1	

func _ready():
	health_bar = get_parent().get_node("PhantomCamera2D/PlrUI/Health")
	if first == true:
		health = _load_from_file("res://data/health.txt")
	if health == "":
		health = 100
		_save_to_file(str(health), "res://data/health.txt")
	
func _save_to_file(content,file_dir):
	var file = FileAccess.open(file_dir, FileAccess.WRITE)
	file.store_string(content)
	
func _load_from_file(file_dir):
	var file = FileAccess.open(file_dir, FileAccess.READ)
	var content = file.get_as_text()
	return content
	
func _process(delta):
	if health_bar.value != float(health):
		health_bar.value = float(health)
		_save_to_file(str(health), "res://data/health.txt")
		print("updated")
	elif float(health) <= 0:
		get_tree().quit()

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_vel
	elif Input.is_action_just_pressed("jump") and is_on_wall() and not cooldown:
		velocity.y = jump_vel
		cooldown = true
	
	if cooldown:
		if not is_on_wall() or is_on_floor():
			cooldown = false
			
	if dashing:
		dashing_timer -= delta
		if dashing_timer <= 0:
			dashing_timer = 0.1
			dashing = false
	elif dashing_cooldown:
		dashing_cooldown_timer -= delta
		if dashing_cooldown_timer <= 0:
			dashing_cooldown_timer = 1
			dashing_cooldown = false
		

	var direction = Input.get_axis("left", "right")
	
	if direction and not dashing:
		velocity.x = direction * speed
	elif not direction and not dashing:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	if Input.is_action_just_pressed("dash_left") and not dashing_cooldown:
		velocity.x = -dash
		dashing = true
		dashing_cooldown = true
	elif Input.is_action_just_pressed("dash_right") and not dashing_cooldown:
		velocity.x = dash
		dashing = true
		dashing_cooldown = true

	move_and_slide()
