extends CharacterBody2D
@onready var anim: AnimationPlayer = get_node("AnimationPlayer")
@onready var sprite2D: Sprite2D = get_node("Slime")
var player_ref = null
const SPEED = 30.0
var cant_die = false
var score = 0
func _physics_process(_delta: float) -> void:
	animate()
	move()
	verify_direction()

func move() -> void:
	if player_ref != null:
		var distance: Vector2 = player_ref.global_position - global_position
		var direction: Vector2 = distance.normalized()
		var distance_length : float = distance.length()
		if distance.length() <= 5:
			player_ref.kill()
			get_tree().change_scene_to_file("res://scenes/level.tscn")
			direction = Vector2.ZERO
			Global.score = 0
		else: velocity = SPEED * direction
			
		velocity = direction * SPEED
	else: velocity = Vector2.ZERO
	move_and_slide()
	
func animate() -> void:
	if cant_die:
		anim.play("dead")
		set_physics_process(false)
	elif velocity != Vector2.ZERO:
		anim.play("walk")
	else: anim.play("idle")
		
func verify_direction() -> void:
	if velocity.x > 0:
		sprite2D.flip_h = false
	elif velocity.x < 0:
		sprite2D.flip_h = true

func on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_ref = body

func on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_ref = null

func _on_animation_finished(anim_name):
	if anim_name == "dead" :
		queue_free()
		Global.score +=1

func kill(area: Area2D) -> void:
	if area.is_in_group("player_attack"):
		cant_die = true
		Global.score += score
		print("entrou")
