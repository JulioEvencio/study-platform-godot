extends CharacterBody2D

@export var sprite : Sprite2D
@export var animation : AnimationPlayer
@export var collision_attack : CollisionShape2D

const SPEED : float = 100.0
const JUMP_VELOCITY : float = -300.0

var direction : float = 0.0
var is_attacking : bool = false
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	animation.play("idle")

func _physics_process(delta : float) -> void:
	to_attack()
	
	if not is_attacking:
		to_apply_gravity(delta)
		to_jump()
		to_move()
	
	animate_sprites()

func to_apply_gravity(delta : float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

func to_jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func to_move() -> void:
	direction = Input.get_axis("move_left", "move_right")
	
	if direction:
		sprite.flip_h = false if direction > 0 else true
		collision_attack.position.x = 9.5 if direction > 0 else -10.5
		
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

func to_attack() -> void:
	if not is_attacking and Input.is_action_just_pressed("attack") and is_on_floor():
		is_attacking = true

func animate_sprites() -> void:
	if is_attacking:
		animation.play("attack")
	elif velocity.y > 0:
		animation.play("fall")
	elif velocity.y < 0:
		animation.play("jump")
	elif direction:
		animation.play("run")
	else:
		animation.play("idle")

func _on_animation_player_animation_finished(anim_name : String) -> void:
	match anim_name:
		"attack":
			is_attacking = false
