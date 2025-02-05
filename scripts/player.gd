extends CharacterBody2D
@onready var anim: AnimationPlayer = get_node("Animation")
@onready var sprite: Sprite2D = get_node("Sprite2D")
@onready var collision: CollisionShape2D = get_node("Attack/collision")
const SPEED = 100.0
var can_die: bool = false
var can_attack: bool = false

func _physics_process(_delta: float) -> void:
	move()
	verify_direction()
	animete()
	attack()

func move() -> void:
	var direction_vector: Vector2 = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	
	velocity = direction_vector * SPEED
	move_and_slide()

func animete() -> void:
	if can_die :
		set_physics_process(false)
		anim.play("dead")
		
	elif can_attack:
		anim.play("attack")
		set_physics_process(false)
	elif velocity != Vector2.ZERO:
		anim.play("run")
	else: 
		anim.play("idle")
	
func attack() -> void:
	if Input.is_action_just_pressed("ui_select") and not can_attack:
		can_attack = true
	
func verify_direction() ->  void:
	if velocity.x > 0:
		sprite.flip_h = false
		collision.position = Vector2(20,8)
	elif velocity.x < 0 :
		sprite.flip_h = true
		collision.position = Vector2(-20,8)

func  kill() -> void:
	can_die = true


func on_animation_finished(anim_name):
	if anim_name == "dead":
		var _reload: bool = get_tree().reload_current_scene()
	elif anim_name == "attack":
		can_attack = false
		set_physics_process(true)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().change_scene_to_file("res://scenes/level_02.tscn")


func _on_back_fase_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().change_scene_to_file("res://scenes/level_03.tscn")


func _body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().change_scene_to_file("res://scenes/final_level.tscn")


 # Replace with function body.
