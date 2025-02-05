extends CharacterBody2D
@onready var anim: AnimationPlayer = get_node("AnimationPlayer")
@onready var sprite2D: Sprite2D = get_node("Sprite2D")
@onready var collision: CollisionShape2D = get_node("BossAttack/CollisionShape2D")
var player_ref = null
const SPEED = 30.0
var cant_die = false
var score = 0
var hp = 30
var can_attack: bool = false
func _physics_process(_delta: float) -> void:
	animate()
	move()
	verify_direction()




func move() -> void:
	if player_ref != null:
		var distance: Vector2 = player_ref.global_position - global_position
		var direction: Vector2 = distance.normalized()
		var distance_length : float = distance.length()
		velocity = direction * SPEED
	else: velocity = Vector2.ZERO
	move_and_slide()
	
func attack() -> void:
	if Input.is_action_just_pressed("ui_select") and not can_attack:
		can_attack = true
func animate() -> void:
	if cant_die:
		anim.play("dead")
		set_physics_process(false)
	elif velocity != Vector2.ZERO:
		anim.play("walk")
	else: anim.play("idle")
		
func verify_direction() ->  void:
	if velocity.x > 0:
		sprite2D.flip_h = false
		collision.position = Vector2(20,8)
	elif velocity.x < 0 :
		sprite2D.flip_h = true
		collision.position = Vector2(-20,8)



func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_ref = body


func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_ref = null





func kill(area: Area2D) -> void:
	if area.is_in_group("player_attack"):
		anim.play("hurt")
		hp -= 5
		set_physics_process(false)
		if hp <= 0:
			cant_die = true
			Global.score += score


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hurt":
		set_physics_process(true)
	if anim_name == "dead" :
		queue_free()
		Global.score +=2
	if anim_name == "attack":
		player_ref.kill()
		
		


func _on_boss_attack_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_ref = body
		anim.play("attack")
		set_physics_process(false)
	
