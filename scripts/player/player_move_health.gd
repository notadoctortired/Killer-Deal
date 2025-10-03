extends CharacterBody2D

@export var speed = 300.0
@export var jump_vel = -400.0
@export var dash = 2000

var health = null
var health_bar = null
var lives = null
var kills = null

var cooldown = false
var no_wallclimb = false
var cooldown_timer = 0.5
var anim_direction = "right"

var dashing = false
var dashing_timer = 0.1
var dashing_cooldown = false
var dashing_cooldown_timer = 1	

var current_scene = null

func _ready():
	lives = _load_from_file("res://data/lives.txt") 
	kills = _load_from_file("res://data/kills.txt")
	
	if lives == "":
		lives = 2
		kills = 0
	elif lives == "0":
		get_tree().quit()
	else:
		lives = int(lives)
		kills = int(kills)
	get_parent().get_node("PhantomCamera2D/PlrUI/Lives").text = str(lives)
	get_parent().get_node("PhantomCamera2D/PlrUI/Kills").text = str(kills)
	
	health_bar = get_parent().get_node("PhantomCamera2D/PlrUI/Health")
	health = _load_from_file("res://data/health.txt")
	current_scene = get_tree().current_scene.scene_file_path
	
	if health == "":
		health = 100
		_save_to_file(str(health), "res://data/health.txt")
		
	health = int(health)
	
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
		health = ""
		lives -= 1
		_save_to_file(str(health), "res://data/health.txt")
		_save_to_file(str(lives), "res://data/lives.txt")
		_save_to_file(str(kills), "res://data/kills.txt")
		
		get_tree().change_scene_to_file(current_scene)

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
			if no_wallclimb == false:
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
		anim_direction = "left"
		$AnimatedSprite2D.play("dash")
	elif Input.is_action_just_pressed("dash_right") and not dashing_cooldown:
		velocity.x = dash
		dashing = true
		dashing_cooldown = true
		anim_direction = "right"
		$AnimatedSprite2D.play("dash")
		
	if direction < 0 and dashing_cooldown == false:
		$AnimatedSprite2D.play("walk_left")
		$Scythe.position.x = -44
		
		anim_direction = "left"
		
	elif direction > 0 and dashing_cooldown == false:
		$AnimatedSprite2D.play("walk_right")
		$Scythe.position.x = 44
		
		anim_direction = "right"
		
	if velocity.x == 0 and anim_direction == "left":
		$AnimatedSprite2D.play("idle_left")
	elif velocity.x == 0 and anim_direction == "right":
		$AnimatedSprite2D.play("idle_right")
		
	

	move_and_slide()
